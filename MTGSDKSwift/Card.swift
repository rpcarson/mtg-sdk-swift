//
//  Card.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation





struct Card {
    
    var name: String?
    var names: [String]?
    var manaCost: String?
    var cmc: Int?
    var colors: [String]?
    var colorIdentity: [String]?
    var type: String?
    var supertypes: [String]?
    var types: [String]?
    var subtypes: [String]?
    var rarity: String?
    var set: String?
    var text: String?
    var artist: String?
    var number: String?
    var power: String?
    var toughness: String?
    var layout: String?
    var multiverseid: Int?
    var imageURL: String?
    var rulings: [[String:String]]?
    var foreignNames: [[String:String]]?
    var printings: [String]?
    var originalText: String?
    var originalType: String?
    var id: String?
    
    var flavor: String?
    
    var loyalty: Int?
    var watermark: Any?
    var reserved: Any?
    var legalities: Any?
    var gameFormat: Any?
    var variations: Any?
    var releaseDate: Any?
    

}
