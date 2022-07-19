//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Евгений Васильев on 18.07.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    //Singleton
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

//MARK: -Account Managemnet
extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> (Void))) {
        
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            //If it's able to do this that mean that email exists already
            guard snapshot.value as? String != nil else {
                //Otherwise if we can't find email
                completion(false)
                
                return
            }
            
            completion(true)
        })
        
    }
    
    //Part5 - 23:00
    
    
    /// Inserts new users to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //        let profilePhotoUrl: String
}


