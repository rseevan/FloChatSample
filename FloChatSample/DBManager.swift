//
//  DBManager.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import Foundation
import SQLite
class DBManager {
    static let instance = DBManager()
    let db: Connection?
 // User Table
    private let users = Table("users")
    
    private let password = Expression<String>("password")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
 
    // Recipe Table
    private let recipes = Table("recipes")

    private let collection_id = Expression<Int>("collection_id")
    private let title = Expression<String>("title")
    private let share_url = Expression<String>("share_url")
    private let url = Expression<String>("url")
    private let description = Expression<String>("description")
    private let image_url = Expression<String>("image_url")
    private let res_count = Expression<Int>("res_count")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/FloChatSample.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(email, unique: true)
                table.column(password)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addUser(cname: String, cemail: String, cpassword: String) -> Int64? {
        do {
            let insert = users.insert(name <- cname, email <- cemail, password <- cpassword)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    func getUsers() -> [UserModel] {
        var users = [UserModel]()
        
        do {
            for user in try db!.prepare(self.users) {
                users.append(UserModel(
                    id: user[id],
                    name: user[name],
                    email: user[email],
                    password: user[password]))
            }
        } catch {
            print("Select failed")
        }
        
        return users
    }
    func verifyUser(cemail: String, cpassword: String) -> Bool {
        var row : Row?
        let query = users.filter(email == cemail && password == cpassword)
        do {
            row = try db!.pluck(query)
        } catch {
            print("error is:\(error)")
        }
        if row != nil {
            return true
        } else {
            return false
        }
    }
    
    func userExists(cemail: String) -> Bool {
        var row : Row?
        let query = users.filter(email == cemail)
        do {
            row = try db!.pluck(query)
        } catch {
            print("error is:\(error)")
        }
        if row != nil {
            return true
        } else {
            return false
        }
    }
    
    // creating recipes table
    
    func createRecipeTable() {
        do {
            try db!.run(recipes.create(ifNotExists: true) { table in
                table.column(collection_id, primaryKey: true)
                table.column(title)
                table.column(description)
                table.column(url)
                table.column(share_url)
                table.column(image_url)
                table.column(res_count)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addRecipe(ccollection_id: Int, ctitle: String, cshare_url: String, curl: String, cdescription: String, cimage_url: String, cres_count: Int ) -> Int64? {
        do {
            let insert = recipes.insert(collection_id <- ccollection_id, title <- ctitle, share_url <- cshare_url, url <- curl, description <- cdescription, image_url <- cimage_url, res_count <- cres_count)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    func getRecipes() -> [recipeModel] {
        var recipes = [recipeModel]()
        
        do {
            for user in try db!.prepare(self.recipes) {
                recipes.append(recipeModel(collection_id: Int64(user[collection_id]), title: user[title], share_url: user[share_url], url: user[url], description: user[description], image_url: user[image_url], res_count: user[res_count]))
            }
        } catch {
            print("Select failed")
        }
        
        return recipes
    }
    
    func parseRecipes(data: [NSDictionary]) {
        createRecipeTable()
        for collection in data {
            let recipe = collection.value(forKey: "collection") as! NSDictionary
            let collection_id = recipe.value(forKey:"collection_id")
            let title = recipe.value(forKey:"title")
            let share_url = recipe.value(forKey:"share_url")
            let url = recipe.value(forKey:"url")
            let description = recipe.value(forKey:"description")
            let image_url = recipe.value(forKey:"image_url")
            let res_count = recipe.value(forKey:"res_count")
            addRecipe(ccollection_id: collection_id as! Int, ctitle: title as! String, cshare_url: share_url as! String, curl: url as! String, cdescription: description as! String, cimage_url: image_url as! String, cres_count: res_count as! Int)
        }
    }
    
}
