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
                        
                        HStack {
                            TextField("e.g., Homemade Pasta Carbonara", text: $dishQuery)
                                .textFieldStyle(.roundedBorder)
                            
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
                            description: Text("Type any dish name above to let the on-device AI create a custom recipe.")
                        )
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Recipe Generator")
        }
    }

    private func generateRecipe() {
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

// MARK: - Recipe Detail Subview
struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.title)
                    .bold()
                Text(recipe.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            // Quick Info Badges
            HStack(spacing: 20) {
                Label("\(recipe.servings) servings", systemImage: "person.2")
                Label("\(recipe.prepMinits)m prep", systemImage: "clock")
                Label("\(recipe.cookMinits)m cook", systemImage: "flame")
            }
            .font(.subheadline)
            .foregroundStyle(.tint)

            Divider()

            // Ingredients
            VStack(alignment: .leading, spacing: 8) {
                Text("Ingredients")
                    .font(.headline)
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                        Text(ingredient.item)
                        Spacer()
                        Text(ingredient.quantity)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            // Steps
            VStack(alignment: .leading, spacing: 12) {
                Text("Instructions")
                    .font(.headline)
                ForEach(recipe.steps, id: \.stepNumber) { step in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: step.symbolName)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.tint)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Step \(step.stepNumber)")
                                .font(.subheadline)
                                .bold()
                            Text(step.instruction)
                                .font(.body)
                        }
                    }
                }
            }

            // Tips
            if !recipe.tips.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Chef's Tips")
                        .font(.headline)
                    ForEach(recipe.tips, id: \.self) { tip in
                        Label(tip, systemImage: "lightbulb")
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}
