//
//  ViewController.swift
//  Messenger
//
//  Created by Евгений Васильев on 16.07.2022.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        //Navigations buttons color
//        UINavigationBar.appearance().tintColor = .systemGreen
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        validateAuth()
    }
    
    private func validateAuth() {
        //Transition to LoginVC
        //If current user is nil, we gonna show all between curly brackets (LoginVC)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            //CreatingOfNavigationVC
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }

}

