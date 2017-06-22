//
//  ServerRequests.swift
//  TestAuthorization

//  Copyright © 2017 ArtSpell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Server {
    
    //init Realm DataBase
    let realm = try! Realm()
    //get object "User" from DataBase
    lazy var users: Results<User> = { self.realm.objects(User.self) }()
    
    let address = "http://174.138.54.52"
    
    //Log in and return response through closures
    func LogIn(username: String, password: String, completion : @escaping (JSON, Swift.Error?) -> ()) {
        let parameters = [
            "username": "\(username)",
            "password":"\(password)"
            ] as Parameters
        
        Alamofire.request("\(address)/authorization/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            switch response.result {
            case .success (let value):
                let json = JSON(value)
                completion(json,nil)
                
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    //registration and return response through closures
    func Registration(username: String, password: String, email: String, completion : @escaping (JSON, Swift.Error?) -> ()) {
        let parameters = [
            "username": "\(username)",
            "password":"\(password)",
            "email":"\(email)"
            ] as Parameters
        
        Alamofire.request("\(address)/authorization/registration", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success (let value):
                let json = JSON(value)
                completion(json,nil)
                
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    //request to the server to receive all users
    func GetAllUsers(completion : @escaping (JSON, Swift.Error?) -> Void) {
        Alamofire.request("\(address)/authorization/allUsers", method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success (let value):
                let json = JSON(value)
                //start write new user to DataBase
                try! self.realm.write() {
                    for (_,userData) in json {
                        let newUser = User()
                        newUser.id = userData["id"].int!
                        if let last_login = userData["last_login"].string {
                            newUser.last_login = self.convertDateToMyFormate(last_login)
                        } else {
                            newUser.last_login = "Was not online"
                        }
                        if let username = userData["username"].string {
                            newUser.username = username
                        }
                        self.realm.add(newUser, update: true)
                    }
                } //end write
                completion(json,nil) //return data
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    func convertDateToMyFormate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateObj = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        return dateFormatter.string(from: dateObj!)
    }
    
}
