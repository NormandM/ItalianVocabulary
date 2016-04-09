//
//  dataStructure.swift
//  VocabulairesItaliens
//
//  Created by Normand Martin on 16-03-20.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import Foundation
struct Vocabulary {
    let frenchVocabulary: String
    let italianVocabulary: String
    func countCharacter (italianVocabulary: String) -> Int {
        return italianVocabulary.characters.count
    }
}