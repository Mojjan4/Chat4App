//
//  Chat4AppApp.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-09.
//

import SwiftUI
import Firebase

@main
struct Chat4App: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
