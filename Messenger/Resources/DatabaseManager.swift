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
    //Part5 - 23:00
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> (Void))) {
        
        //Handle of errors of forbidden symbols
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            //If it's able to do this that mean that email exists already
            guard snapshot.value as? String != nil else {
                //Otherwise if we can't find email
                completion(false)
                
                return
            }
            
            completion(true)
        })
    }
    
    
    /// Inserts new users to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //        let profilePhotoUrl: String
}


