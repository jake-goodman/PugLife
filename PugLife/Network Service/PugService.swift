//
//  PugService.swift
//  PugLife
//
//  Created by Jake Goodman on 9/20/18.
//  Copyright © 2018 Jake Goodman. All rights reserved.
//

import Foundation

class PugService {
    
    fileprivate enum Constants {
        static let baseURL = URL(string: "https://pugme.herokuapp.com/bomb?count=50")!
    }

    func getPugs(completion: @escaping ([PLPug], Error?)->Void) {
        var request = URLRequest(url: Constants.baseURL)
        request.httpMethod = "GET"
        
        _  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion([], error)
                return
            }
            var pugs: [PLPug] = []
            if let jsonDict = json as? [String: Any], let pugPaths = jsonDict["pugs"] as? [String]  {
                pugs = pugPaths.compactMap() { (path) in
                    if let url = URL(string: path) {
                        return PLPug(url: url)
                    }
                    return nil
                }
            }
            completion(pugs, error)
        }.resume()
    }
    
}
