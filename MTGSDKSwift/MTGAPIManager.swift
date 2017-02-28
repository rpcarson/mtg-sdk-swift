//
//  MTGAPIManager.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

let magic = Magic()
func pop() {
    magic.settings.pageSize = "100"
    let y = Magic.Settings.access
}


final public class Magic {
    final private class Settings {
        private init() {}
        static internal let access = Settings()
        var pageSize: String = "6"
        var pageNumber: String = "1"
        var errorLogging: Bool = false
    }
    
    let settings = Settings.access
    
    private let mtgAPIService = MTGAPIService()
    private let urlManager = URLManager()
    private let parser = JSONParser()
    
    func fetchCardsWithParameters(_ parameters: [SearchParameter], completion: @escaping ([Card]?) -> Void) throws {
        
        urlManager.pageSize = settings.pageSize
        urlManager.page = settings.pageNumber
        
        guard let url = urlManager.buildURL(parameters: parameters) else {
            print("Magic: bad url")
            return
        }
        
        var networkError: NetworkError?
        
        mtgAPIService.networkQuery(url: url) {
            json, error in
            
            if error != nil {
                networkError = error
                return
            }
            
            let cards = self.parser.parseJSONResults(json: json!, resultsType: .cards).cards
            
            completion(cards)
            
        }
        
        if let error = networkError {
            throw error
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
        urlComponents.path = "/v1/cards"
        urlComponents.queryItems = buildQueryItemsFromParameters(parameters)
        
        
        return urlComponents.url
    }
    
    private func buildQueryItemsFromParameters(_ parameters: [SearchParameter]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        let pageSizeQuery = URLQueryItem(name: "pageSize", value: pageSize)
        let pageQuery = URLQueryItem(name: "page", value: page)
        queryItems.append(pageQuery)
        queryItems.append(pageSizeQuery)
        
        for parameter in parameters {
            let name = parameter.paramType.rawValue
            let value = parameter.value
            let item = URLQueryItem(name: name, value: value)
            queryItems.append(item)
        }
        
        return queryItems
    }
    
    
    
}


enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case unexpectedResults(Data)
    case unknownError
}

typealias JSONResults = [String:Any]
typealias JSONCompletionWithError = ([String:Any]?, NetworkError?) -> Void
typealias JSONCompletion = ([String:Any]) -> Void


let testURL = URL(string: "https://api.magicthegathering.io/v1/cards?pageSize=20&subtypes=warrior&set=KTK&text=warrior")




final private class MTGAPIService {
    
    func networkQuery(url: URL, completion: @escaping JSONCompletionWithError) {
        
        let  networkOperation = NetworkOperation(url: url)
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError!)
                return
            }
        }
        
        networkOperation.queryURL {
            json, error in
            
            if error != nil {
                networkError = error
                return
            }
            completion(json!, nil)
        }
        
        if let error = networkError {
            completion(nil, error)
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
        
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
                return
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
                    print("HTTPResponse success. code: \(httpResponse.statusCode)")
                    break
                default:
                    networkError = NetworkError.unexpectedHTTPResponse(httpResponse)
                    return
                }
            }
            
            guard data != nil else {
                networkError = NetworkError.unknownError
                return
            }
            
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? JSONResults
                completion(jsonResponse, nil)
            } catch {
                networkError = NetworkError.unexpectedResults(data!)
                return
            }
        }
        
        dataTask.resume()
        
    }
    
    
    //    func downloadSubtypesData(completion: @escaping (JSONResults) -> Void) {
    //
    //        guard let url = URL(string: "https://api.magicthegathering.io/v1/subtypes") else {
    //            print("MTGAPIService:downloadSetsData - url failed")
    //            return
    //        }
    //
    //        let networkOperation = NetworkOperation(url: url)
    //
    //        networkOperation.retrieveJSON { (results) in
    //            if let sets = results {
    //                print("MTGAPIService:downloadSetsData - operation success")
    //                print(sets)
    //                completion(sets)
    //            }
    //        }
    //
    //    }
    //    func downloadSetsData(completion: @escaping (JSONResults) -> Void) {
    //
    //        guard let url = URL(string: "https://api.magicthegathering.io/v1/sets") else {
    //            print("MTGAPIService:downloadSetsData - url failed")
    //            return
    //        }
    //
    //        let networkOperation = NetworkOperation(url: url)
    //
    //        networkOperation.retrieveJSON { (results) in
    //            if let sets = results {
    //                print("MTGAPIService:downloadSetsData - operation success")
    //                completion(sets)
    //            }
    //        }
    //
    //    }
    
    
}













//
