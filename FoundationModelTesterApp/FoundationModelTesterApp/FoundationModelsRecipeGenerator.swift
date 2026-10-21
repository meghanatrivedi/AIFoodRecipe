//
//  FoundationModelsRecipeGenerator.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 21/10/26.
//

import Foundation
import FoundationModels

final class FoundationModelsRecipeGenerator: RecipeGenerating {
    
    func prewarm() {
        // Optional prewarming
    }
    
    func generateRecipe(for dishQuery: String) async throws -> Recipe {
        // Create a fresh session for every request to avoid context buildup / state collision
        let session = LanguageModelSession {
            """
            You are a friendly cookery assistant.
            When given a dish name, generate a complete, accurate, and detailed recipe matching the requested schema. 
            Do not reference any previous recipes or past conversation context.
            """
        }
        
        let response = try await session.respond(generating: Recipe.self) {
            "Generate a delicious recipe for: \(dishQuery)"
        }
        
        return response.content
    }
}
