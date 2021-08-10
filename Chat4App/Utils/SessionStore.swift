//
//  SessionStore.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-09.
//

import Foundation
import FirebaseAuth

struct User {
    var uid: String
    var email: String
}

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var isAnonymous: Bool = false
    
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    func listen () {
        handle = authRef.addStateDidChangeListener({(auth, user) in
            if let user = user {
                self.isAnonymous = false
                self.session = User(uid: user.uid, email: user.email!)
            } else {
                self.isAnonymous = true
                self.session = nil
            }
        })
    }
    
    func signIn (email: String, password: String) {
        authRef.signIn(withEmail: email, password: password)
    }
    
    func signUp (email: String, password: String) {
        authRef.createUser(withEmail: email, password: password)
    }
    
    func signOut () -> Bool {
        do {
            try authRef.signOut()
            self.session = nil
            self.isAnonymous = true
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
}


