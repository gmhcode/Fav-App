//
//  PostController.swift
//  Why iOS
//
//  Created by Greg Hughes on 12/12/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import Foundation
import UIKit
class PostController {
    
    static let baseUrl = URL(string: "https://favoriteapp-375c6.firebaseio.com/users")
    
    static func fetchPosts( completion: @escaping ([Post]?) -> Void){
        
        
        guard let url = baseUrl else { completion (nil) ; return}
        
        let fullUrl = url.appendingPathExtension("json")
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {completion(nil) ; return}
            
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : [ String : String]]
                let posts = jsonDictionary?.compactMap({ Post(dictionary: $0.value) })
                
                completion(posts)
            }
            catch{
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(nil)
            }
            
            }.resume()
        
    }
    
    
    
    static func addPost( name: String, favApp: String, completion: @escaping () -> ()) {
        
        
        guard let url = baseUrl?.appendingPathExtension("json") else {completion() ; return}
        
        let post = Post(name: name, favApp: favApp)
        
        var postData : Data
        
        do {
            
            let jsonDecoder = JSONEncoder()
            let newPost = try jsonDecoder.encode(post)
            postData = newPost
        }catch{
            
            print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
            completion()
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpBody = postData
        request.httpMethod = "Post"
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion()
            }
            
            print(response ?? "NO Responses")
            completion()
            fetchPosts(completion: { (_) in
                
            })
            
            }.resume()
        
        
    }
    
}
