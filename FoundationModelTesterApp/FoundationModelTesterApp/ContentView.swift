//
//  ContentView.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 21/10/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var dishQuery = ""
    @State private var recipe: Recipe?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var speechManager = SpeechSearchManager()
    
    // Automatically switch between real AI model and mock based on device capabilities
    private let recipeGenerator: RecipeGenerating = {
        if SystemLanguageModel.default.isAvailable {
            return FoundationModelsRecipeGenerator()
        } else {
            return MockRecipeGenerator()
        }
    }()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Input Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What would you like to cook?")
                            .font(.headline)
                        
                        HStack(spacing: 10) {
                            TextField("e.g., Homemade Pasta Carbonara", text: $dishQuery)
                                .textFieldStyle(.roundedBorder)
                            
                            // Speech Search Microphone Button
                            Button {
                                handleMicButtonTapped()
                            } label: {
                                Image(systemName: speechManager.isRecording ? "mic.fill" : "mic")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(speechManager.isRecording ? .white : .accentColor)
                                    .frame(width: 36, height: 36)
                                    .background(speechManager.isRecording ? Color.red : Color(.secondarySystemFill))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(speechManager.isRecording ? "Stop recording" : "Search by voice")

                            Button(action: generateRecipe) {
                                if isLoading {
                                    ProgressView()
                                        .frame(width: 60, height: 20)
                                } else {
                                    Text("Generate")
                                        .fontWeight(.semibold)
                                        .frame(minWidth: 70)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(dishQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                        }
                        
                        if speechManager.isRecording {
                            Text("Listening... Speak your dish name.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        if !SystemLanguageModel.default.isAvailable {
                            Label("Running on Mock Generator (Apple Intelligence unavailable)", systemImage: "exclamationmark.triangle")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Error Handling Banner
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.callout)
                            .padding()
                    }

                    // Recipe Display View
                    if let recipe {
                        RecipeDetailView(recipe: recipe)
                    } else if !isLoading {
                        ContentUnavailableView(
                            "No Recipe Generated",
                            systemImage: "fork.knife.circle",
                            description: Text("Type or speak any dish name above to let the AI create a custom recipe.")
                        )
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Recipe Generator")
        }
        .onChange(of: speechManager.transcribedText) { oldValue, newValue in
            if !newValue.isEmpty {
                dishQuery = newValue
            }
        }
    }

    private func handleMicButtonTapped() {
        if speechManager.isRecording {
            speechManager.stopRecording()
        } else {
            errorMessage = nil
            speechManager.requestAuthorization { granted in
                guard granted else {
                    errorMessage = "Microphone or Speech Recognition permission denied. Check Settings or Simulator permissions."
                    return
                }
                do {
                    try speechManager.startRecording { spokenText in
                        dishQuery = spokenText
                        generateRecipe()
                    }
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func generateRecipe() {
        if speechManager.isRecording {
            speechManager.stopRecording()
        }
        
        let query = dishQuery
        isLoading = true
        errorMessage = nil

        Task {
            do {
                recipeGenerator.prewarm()
                let generatedRecipe = try await recipeGenerator.generateRecipe(for: query)
                await MainActor.run {
                    self.recipe = generatedRecipe
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
