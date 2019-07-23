//
//  Recipe.swift
//  Food101Prediction
//
//  Created by Marij on 01/01/2019.
//  Copyright © 2019 Philipp Gabriel. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    var label: String
    var ingredientLines: [String]
    var calories: String
}
