//
//  ChatList.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-09.
//

import SwiftUI

struct ChatList: View {
    
    @ObservedObject var viewModel = ChatroomsViewModel()
    @State var joinModal = false
    
    init () {
        viewModel.fetchData()
    }

    var body: some View {
        NavigationView {
            List(viewModel.chatrooms) { chatroom in
                NavigationLink(destination: Messages(chatroom: chatroom)) {
                    HStack {
                        Text(chatroom.tittle)
                        Spacer()
                    }
                }
                .navigationBarTitle("Chatrooms")
                .navigationBarItems(trailing: Button(action: {
                    self.joinModal = true
                }, label: {
                    Image(systemName: "plus.circle")
                }))
            }
            .sheet(isPresented: $joinModal, content:  {
                Join(isOpen: $joinModal)
            })
        }
           
    }
}
struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
