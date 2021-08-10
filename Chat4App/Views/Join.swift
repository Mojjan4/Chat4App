//
//  Join.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-10.
//

import SwiftUI

struct Join: View {
    
    @Binding var isOpen: Bool
    @State var joinCode = ""
    @State var newtitle = ""
    @ObservedObject var viewModel = ChatroomsViewModel()
    
    var body: some View {
        NavigationView {
            VStack  {
                VStack {
                    Text("Join or create chatroom")
                        .font(.title)
                    TextField("Enter your join code", text: $joinCode)
                    Button(action: {
                        viewModel.joinChatroom(code: joinCode, handler: {
                            self.isOpen = false
                        })
                    }, label: {
                        Text("Join")
                    })
                }
                .padding(.bottom)
                
                VStack {
                    Text("Create a chatroom")
                        .font(.title)
                    TextField("Enter a new title", text: $newtitle)
                    Button(action: {
                        viewModel.createChatroom(title: newtitle, handler: {
                            self.isOpen = false
                        })
                    }, label: {
                        Text("Create")
                    })
                }
                .padding(.top)
            }
            .navigationTitle("Join or create")
        }
    }
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        Join(isOpen: .constant(true))
    }
}