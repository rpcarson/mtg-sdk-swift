//
//  MagicalCardManager.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/1/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import UIKit


final public class Magic {
    public init() {}

    public typealias CardImageCompletion = (UIImage?, NetworkError?) -> Void
    public typealias CardCompletion = ([Card]?, NetworkError?) -> Void
    public typealias SetCompletion = ([CardSet]?, NetworkError?) -> Void
    
    public static var enableLogging: Bool = false
    public var fetchPageSize: String = "12"
    public var fetchPageTotal: String = "1"
    
    private let mtgAPIService = MTGAPIService()
    private var urlManager: URLManager {
        let urlMan = URLManager()
        urlMan.pageTotal = fetchPageTotal
        urlMan.pageSize = fetchPageSize
        return urlMan
    }
    private let parser = Parser()
    
    
    public func fetchJSON(_ parameters: [SearchParameter], completion: @escaping JSONCompletionWithError) {
        
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        guard let url = urlManager.buildURL(parameters: parameters) else {
            networkError = NetworkError.miscError("fetchJSON url build failed")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            json, error in
            if let error = error {
                networkError = NetworkError.requestError(error)
                return
            }
            completion(json, nil)
        }
        
    }
    
    
    public func fetchImageForCard(_ card: Card, completion: @escaping CardImageCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        guard let imgurl = card.imageURL else {
            networkError = NetworkError.fetchCardImageError("fetchImageForCard card imageURL was nil")
            return
        }
        
        guard let url = URL(string: imgurl) else {
            networkError = NetworkError.fetchCardImageError("fetchImageForCard url build failed")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let img = UIImage(data: data) {
                completion(img, nil)
            } else {
                networkError = NetworkError.fetchCardImageError("could not create uiimage from data")
            }
            
        } catch {
            networkError = NetworkError.fetchCardImageError("data from contents of url failed")
        }
        
    }
    
    
    public func fetchSets(_ parameters: [SetSearchParameter], completion: @escaping SetCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        if let url = urlManager.buildURL(parameters: parameters) {
            mtgAPIService.mtgAPIQuery(url: url) {
                json, error in
                if error != nil {
                    networkError = error
                    return
                }
                let sets = self.parser.parseSets(json: json!)
                completion(sets, nil)
            }
        } else {
            networkError = NetworkError.miscError("fetchSets url build failed")
        }
        
    }
    
    public func fetchCards(_ parameters: [CardSearchParameter], completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        if let url = urlManager.buildURL(parameters: parameters) {
            mtgAPIService.mtgAPIQuery(url: url) {
                json, error in
                if error != nil {
                    networkError = error
                    return
                }
                let cards = self.parser.parseCards(json: json!)
                completion(cards, nil)
            }
        } else {
            networkError = NetworkError.miscError("fetchCards url build failed")
        }
        
    }
    
}
