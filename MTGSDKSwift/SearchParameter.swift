//
//  SearchParameter.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation


public enum SetQueryParameterType: String {
    case name
    case block
}

public enum CardQueryParameterType: String {
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


public class SearchParameter {
        
    public var name: String {
        return ""
    }
    public var value: String = ""

}


public class CardSearchParameter: SearchParameter {
    override public var name: String {
        return paramType.rawValue
    }
   
    private var paramType: CardQueryParameterType
    
    public init(parameterType: CardQueryParameterType, value: String) {
        self.paramType = parameterType
        super.init()
        self.value = value
                
            }
    
}
public class SetSearchParameter: SearchParameter {
    override public var name: String {
        return paramType.rawValue
    }
    
    private var paramType: SetQueryParameterType
    
    public init(parameterType: SetQueryParameterType, value: String) {
        self.paramType = parameterType
        super.init()
        self.value = value
        
    }
}

//public struct SetSearchParameter {
//    public let paramType: SetQueryParameterType
//    
//    public let value: String
//    
//    public init(parameterType: SetQueryParameterType, value: String) {
//        self.paramType = parameterType
//        
//        self.value = value
//        
//    }
//}
//
//



//public struct SetSearchParameter {
//    
//    public let paramType: SetQueryParameterType
//    public let value: String
//    
//    public init(parameterType: SetQueryParameterType, value: String) {
//        self.paramType = parameterType
//        self.value = value
//        
//    }
//}
//public struct CardSearchParameter {
//   
//    public let paramType: CardQueryParameterType
//    public let value: String
//    
//    public init(parameterType: CardQueryParameterType, value: String) {
//        self.paramType = parameterType
//        self.value = value
//        
//    }
//}















//
