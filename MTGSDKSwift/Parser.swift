//
//  Parser.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation




enum JSONResultType: String {
    case cards
    case sets
}



final class Parser {
    
     func parseCards(json: JSONResults) -> [Card]? {
        
        guard let cards = json["cards"] as? [[String:Any]] else {
            print("json cards parse guard fail")
            return nil
        }
        
        var cardsArray = [Card]()
        
        for c in cards {
            
            var card = Card()
            
            if let name = c["name"] as? String {
                card.name = name
            }
            if let names = c["names"] as? [String] {
                card.names = names
            }
            if let manaCost = c["manaCost"] as? String {
                card.manaCost = manaCost
            }
            if let cmc = c["cmc"] as? Int {
                card.cmc = cmc
            }
            if let colors = c["colors"] as? [String] {
                card.colors = colors
            }
            if let colorIdentiy = c["colorIdentity"] as? [String] {
                card.colorIdentity = colorIdentiy
            }
            if let type = c["type"] as? String {
                card.type = type
            }
            if let supertypes = c["supertypes"] as? [String] {
                card.supertypes = supertypes
            }
            if let types = c["types"] as? [String] {
                card.types = types
            }
            if let subtypes = c["subtypes"] as? [String] {
                card.subtypes = subtypes
            }
            if let rarity = c["rarity"] as? String {
                card.rarity = rarity
            }
            if let set = c["set"] as? String {
                card.set = set
            }
            if let text = c["text"] as? String {
                card.text = text
            }
            if let artist = c["artist"] as? String {
                card.artist = artist
            }
            if let number = c["number"] as? String {
                card.number = number
            }
            if let power = c["power"] as? String {
                card.power = power
            }
            if let toughness = c["toughness"] as? String {
                card.toughness = toughness
            }
            if let layout = c["layout"] as? String {
                card.layout = layout
            }
            if let multiverseid = c["multiverseid"] as? Int {
                card.multiverseid = multiverseid
            }
            if let imageURL = c["imageURL"] as? String {
                card.imageURL = imageURL
            }
            if let rulings = c["rulings"] as? [[String:String]] {
                card.rulings = rulings
            }
            if let foreignNames = c["foreignNames"] as? [[String:String]] {
                card.foreignNames = foreignNames
            }
            if let printings = c["printings"] as? [String] {
                card.printings = printings
            }
            if let originalText = c["originalText"] as? String {
                card.originalText = originalText
            }
            if let originalType = c["originalType"] as? String {
                card.originalType = originalType
            }
            if let id = c["id"] as? String {
                card.id = id
            }
            
            cardsArray.append(card)
           
        }
        
        return cardsArray
    }
    
    private func parseSets(json: JSONResults) -> [CardSet]? {
        
        guard let cardSets = json["sets"] as? [[String:Any]] else {
            print("sets parse guard fail")
            return nil
        }
        
        var sets = [CardSet]()
        
        for s in cardSets {
            var set = CardSet()
            
            if let name = s["name"] as? String {
                set.name = name
            }
            
            
            
            
            sets.append(set)
        }
        
        
        return sets
        
    }

    
}
