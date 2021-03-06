//
//  AppDelegate.swift
//  Messenger
//
//  Created by Евгений Васильев on 16.07.2022.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
//        return GIDSignIn.sharedInstance.handle(url)
        
        return ((GIDSignIn.sharedInstance()?.handle(url)) != nil)
        
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to Sign In with Google: \(error)")
            }
            
            return
        }
        
        guard let user = user else {
            return
        }
        
        print("Did sign in with Google: \(user)")
        
        guard let email = user.profile.email,
              let firstName =  user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                //Insert to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
            }
            
        })
        
        guard let authentication = user.authentication,
              let idToken = authentication.idToken
        else {
            print("Missing auth object of google user")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("Failed to log in with google credential")
                return
            }
            
            print("Successfully signed in with Google cred.")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
    
}


