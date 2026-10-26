//
//  RecipeDetailView.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 26/10/26.
//
import SwiftUI
import FoundationModels

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
