//
//  UserModel.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import Foundation

class UserModel {
    let id: Int64?
    var name: String
    var email: String
    var password: String
    
    init(id: Int64) {
        self.id = id
        name = ""
        email = ""
        password = ""
    }
    
    init(id: Int64, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
    
}
