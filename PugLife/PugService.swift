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

    func getPugs(completion: @escaping ([Pug], Error?)->Void) {
        var request = URLRequest(url: Constants.baseURL)
        request.httpMethod = "GET"
        
        _  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion([], error)
                return
            }
            var pugs: [Pug] = []
            if let jsonDict = json as? [String: Any], let pugPaths = jsonDict["pugs"] as? [String]  {
                for path in pugPaths {
                    if let url = URL(string: path) {
                        pugs.append(Pug(url: url))
                    }
                }
            }
            completion(pugs, error)
        }.resume()
    }
    
}
