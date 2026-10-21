//
//  Recipe.swift
//  FoundationModelTesterApp
//
//  Created by Meggi on 21/10/26.
//

import FoundationModels
@Generable()

struct Recipe{
    var title:String
    var summary:String
    var servings:Int
    var prepMinits:Int
    var cookMinits:Int
    var ingredients:[Ingredient]
    var steps:[RecipeStep]
    var tips:[String]
    var safetyNotes: [String]
}
