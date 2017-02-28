//
//  MTGAPIManager.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation


public enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case unexpectedResults(Data)
    case invalidParameters(String)
    case nilDataResponse
    case serializationError
}


final public class MagicSettings {
    private init() {}
    static let instance = MagicSettings()
    public var pageSize: String = "6"
    public var pageNumber: String = "1"
    public var enableLogging: Bool = true
}


final public class MagicManager {
    
    public typealias CardCompletion = ([Card]?, NetworkError?) -> Void
    public typealias SetCompletion = ([CardSet]?, NetworkError?) -> Void
    
    public init() {}
    public let settings = MagicSettings.instance
    
    private let mtgAPIService = MTGAPIService()
    private let urlManager = URLManager()
    private let parser = Parser()

    public func fetchSets(_ parameters: [SearchParameter], completion: @escaping SetCompletion) throws {
        
        var networkError: NetworkError? {
            didSet {
                if settings.enableLogging {
                    print("fetchSets networkError")
                }
                completion(nil, networkError)
            }
        }
        
        if parameters is [CardSearchParameter] {
            networkError = NetworkError.invalidParameters("fetchSets: card parameters passed")
            completion(nil, networkError)
            return
        }
        
        urlManager.pageSize = settings.pageSize
        urlManager.page = settings.pageNumber
        
        guard let url = urlManager.buildURL(parameters: parameters) else {
            if settings.enableLogging {
                print("fetchSets bad url")
            }
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            json, error in
            if error != nil {
                networkError = error
                return
            }
            let sets = self.parser.parseSets(json: json!)
            completion(sets, nil)
        }
    }
    
    public func fetchCards(_ parameters: [SearchParameter], completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                if settings.enableLogging {
                    print("fetchCards networkError")
                }
                completion(nil, networkError)
            }
        }
        
        if parameters is [SetSearchParameter] {
            networkError = NetworkError.invalidParameters("fetchCards: sets parameters passed")
            completion(nil, networkError)
            return
        }
        
        urlManager.pageSize = settings.pageSize
        urlManager.page = settings.pageNumber
        
        guard let url = urlManager.buildURL(parameters: parameters) else {
            if settings.enableLogging {
                print("fetchCards bad url")
            }
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            json, error in
            if error != nil {
                networkError = error
                return
            }
            let cards = self.parser.parseCards(json: json!)
            completion(cards, nil)
        }

    }

}


final class URLManager {
    
    var pageSize = "6"
    var page = "1"
    
    func buildURL(parameters: [SearchParameter]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.magicthegathering.io"
        urlComponents.path = {
            if parameters is [CardSearchParameter] {
                return "/v1/cards"
            } else {
                return "/v1/sets"
            }
        }()
        
        urlComponents.queryItems = buildQueryItemsFromParameters(parameters)
        
        if MagicSettings.instance.enableLogging == true {
            if let url = urlComponents.url {
                 print("URL constructed: \(url)")
            }
        }
        
        return urlComponents.url
        
    }
    
    private func buildQueryItemsFromParameters(_ parameters: [SearchParameter]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        let pageSizeQuery = URLQueryItem(name: "pageSize", value: pageSize)
        let pageQuery = URLQueryItem(name: "page", value: page)
        queryItems.append(pageQuery)
        queryItems.append(pageSizeQuery)
        
        for parameter in parameters {
            let name = parameter.name
            let value = parameter.value
            let item = URLQueryItem(name: name, value: value)
            queryItems.append(item)
        }
        
        return queryItems
    }
    
}

typealias JSONResults = [String:Any]
typealias JSONCompletionWithError = ([String:Any]?, NetworkError?) -> Void
typealias JSONCompletion = ([String:Any]) -> Void


let testURL = URL(string: "https://api.magicthegathering.io/v1/cards?pageSize=20&subtypes=warrior&set=KTK&text=warrior")




final private class MTGAPIService {
    
    func mtgAPIQuery(url: URL, completion: @escaping JSONCompletionWithError) {
        
        if MagicSettings.instance.enableLogging {
            print("MTGAPIService - beginning mtgAPIQuery... \n")
        }
        
        let  networkOperation = NetworkOperation(url: url)
        var networkError: NetworkError? {
            didSet {
                if MagicSettings.instance.enableLogging {
                    print("MTGAPIService networkQuery error")
                }
                completion(nil, networkError)
            }
        }
        
        networkOperation.queryURL {
            json, error in
            
            if error != nil {
                networkError = error
                return
            }
            completion(json, nil)
        }

    }
    
}



final private class NetworkOperation {
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }

    func queryURL(completion: @escaping JSONCompletionWithError) {
        
        if MagicSettings.instance.enableLogging {
            print("NetworkOperation - beginning queryURL... \n")
        }
        
        var networkError: NetworkError? {
            didSet {
                if MagicSettings.instance.enableLogging {
                    print("NetworkOperation queryURL error")
                }
                completion(nil, networkError)
            }
        }
        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                networkError = NetworkError.requestError(error!)
                return
            }
            
            if let httpResponse = (response as? HTTPURLResponse) {
                switch httpResponse.statusCode {
                case 200..<300:
                    if MagicSettings.instance.enableLogging {
                        print("HTTPResponse success - status code: \(httpResponse.statusCode)")
                    }
                    break
                default:
                    if MagicSettings.instance.enableLogging {
                        print("HTTPResponse unexpected - status code: \(httpResponse.statusCode)")
                    }
                    networkError = NetworkError.unexpectedHTTPResponse(httpResponse)
                    return
                }
            }
            
            guard data != nil else {
                if MagicSettings.instance.enableLogging {
                    print("NetworkOperation queryURL: error - data response is nil")
                }
                networkError = NetworkError.nilDataResponse
                return
            }
            
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? JSONResults
               
                completion(jsonResponse, nil)
            
            } catch {
                if MagicSettings.instance.enableLogging {
                    print("NetworkOperation queryURL - json serialization fail catch block")
                }
                networkError = NetworkError.serializationError
                return
            }
        }
        
        dataTask.resume()

    }
    
    
}













//
