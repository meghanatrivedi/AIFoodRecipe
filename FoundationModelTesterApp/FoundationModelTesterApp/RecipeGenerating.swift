//
//  RecipeGenerating.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 21/10/26.
//

import Foundation

protocol RecipeGenerating{
    func prewarm()
    func generateRecipe(for dishQuery:String) async throws -> Recipe
}
