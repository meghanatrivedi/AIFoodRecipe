//
//  MockRecipeGenerator.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 21/10/26.
//

import Foundation
import FoundationModels

final class MockRecipeGenerator: RecipeGenerating {
    func prewarm() {
        // Perform any necessary pre-initialization tasks here
    }

    func generateRecipe(for dishQuery: String) async throws -> Recipe {
        let title = dishQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeTitle = title.isEmpty ? "Classic Homemade Dish" : title

        return Recipe(
            title: safeTitle.capitalized,
            summary:
                "A delicious, restaurant-quality homemade version of \(safeTitle.lowercased()) made with simple, fresh ingredients.",
            servings: 4,
            prepMinits: 15,
            cookMinits: 25,
            ingredients: [
                Ingredient(item: "Primary Component", quantity: "2 cups"),
                Ingredient(item: "Extra Virgin Olive Oil", quantity: "2 tbsp"),
                Ingredient(item: "Garlic (minced)", quantity: "2 cloves"),
                Ingredient(
                    item: "Sea Salt & Black Pepper",
                    quantity: "To taste"
                ),
            ],
            steps: [
                RecipeStep(
                    stepNumber: 1,
                    instruction:
                        "Gather and prep all fresh ingredients at room temperature.",
                    symbolName: "tray.and.arrow.down"
                ),
                RecipeStep(
                    stepNumber: 2,
                    instruction:
                        "Heat oil in a large skillet or pan over medium heat.",
                    symbolName: "flame"
                ),
                RecipeStep(
                    stepNumber: 3,
                    instruction:
                        "Combine components and cook gently until fully tender and aromatic.",
                    symbolName: "fork.knife"
                ),
                RecipeStep(
                    stepNumber: 4,
                    instruction:
                        "Season with salt and pepper to taste, then serve warm.",
                    symbolName: "checkmark.circle"
                ),
            ],
            tips: [
                "For an extra flavor boost, garnish with fresh herbs just before serving.",
                "Store any leftovers in an airtight container in the refrigerator for up to 3 days.",
            ],
            safetyNotes: [
                "Ensure ingredients are washed thoroughly before preparation.",
                "Always use oven mitts when handling hot cookware.",
            ]
        )
    }
}
