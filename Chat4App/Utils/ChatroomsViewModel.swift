//
//  ChatroomsViewModel.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-09.
//

import Foundation
import Firebase

struct Chatroom: Codable, Identifiable {
    var id: String
    var tittle: String
    var joinCode: Int
}

class ChatroomsViewModel: ObservableObject {
    
    @Published var chatrooms = [Chatroom]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func fetchData () {
        if (user != nil) {
            db.collection("chatrooms").whereField("users", arrayContains: user!.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print ("No documents returned!")
                    return
                }
                
                self.chatrooms = documents.map({docSnapshot -> Chatroom in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let joinCode = data["joinCode"] as? Int ?? -1
                    return Chatroom(id: docId, tittle: title, joinCode: joinCode)
                    
                })
            })
        }
    }
    
    func createChatroom(title: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chatrooms").addDocument(data: [
                                                    "title": title,
                                                    "joinCode": Int.random(in: 10000..<99999),
                                                    "users": [user!.uid]]) { err in
                if let err = err {
                    print("Error adding document \(err)")
                } else {
                    handler()
                }
            }
        }
    }
    
    func joinChatroom(code: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(code)).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("Error getting documents! \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.db.collection("chatrooms").document(document.documentID).updateData([
                                                                                                    "users": FieldValue.arrayUnion([self.user!.uid
                                                                                                    ])])
                        handler()
                    }
                }
            }
        }
    }
}
