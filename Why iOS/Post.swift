//
//  Post.swift
//  Why iOS
//
//  Created by Greg Hughes on 12/12/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import Foundation

struct Post: Codable  {
    
    let favApp: String
    let name: String
    
    init?(dictionary: [String : String] ){
        
        guard let name = dictionary["name"],
            let favApp = dictionary["favApp"] else {return nil}
        
        self.favApp = favApp
        self.name = name
      
    }
    
    init(name: String, favApp: String){
        self.name = name
        self.favApp = favApp
    }
    
    
}
