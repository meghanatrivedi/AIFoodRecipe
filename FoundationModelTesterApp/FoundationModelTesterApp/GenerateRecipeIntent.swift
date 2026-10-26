//
//  GenerateRecipeIntent.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 26/10/26.
//
import SwiftUI
import FoundationModels
import AppIntents

struct GenerateRecipeIntent: AppIntent {
    static var title: LocalizedStringResource = "Generate Recipe"
    static var description = IntentDescription("Generates a custom cooking recipe for a specified dish name.")

    @Parameter(title: "Dish Name", description: "The name of the dish you want a recipe for.")
    var dishName: String

    static var parameterSummary: some ParameterSummary {
        Summary("Generate a recipe for \(\.$dishName)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let generator: RecipeGenerating = MockRecipeGenerator()
        let recipe = try await generator.generateRecipe(for: dishName)
        
        let responseMessage = "Recipe generated for \(recipe.title). Prep time: \(recipe.prepMinits) minutes."
        return .result(value: responseMessage, dialog: "Here is your recipe for \(recipe.title)! \(recipe.summary)")
    }
}

struct RecipeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GenerateRecipeIntent(),
            phrases: [
                "Generate a recipe in \(.applicationName)",
                "Cook something with \(.applicationName)"
            ],
            shortTitle: "Generate Recipe",
            systemImageName: "fork.knife"
        )
    }
}
