//
//  SearchParameter.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation





enum SearchParameterType: String {
    case name
    case cmc
    case colors
    case type
    case supertypes
    case subtypes
    case rarity
    case text
    case set
    case artist
    case power
    case toughness
    case multiverseid
    case gameFormat
    
}

struct SearchParameter {
   
    let paramType: SearchParameterType
    
    let value: String
    
    init(parameterType: SearchParameterType, value: String) {
        self.paramType = parameterType
        
        self.value = value
        
    }
}















//
