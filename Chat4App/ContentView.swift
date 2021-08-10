//
//  ContentView.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-09.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sessionStore = SessionStore()
    
    init () {
        sessionStore.listen()
    }
    
    var body: some View {
        ChatList()
            .fullScreenCover(isPresented: $sessionStore.isAnonymous, content: {
                Login()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
