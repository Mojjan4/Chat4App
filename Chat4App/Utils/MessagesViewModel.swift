//
//  MessagesViewModel.swift
//  Chat4App
//
//  Created by Christopher on 2021-08-10.
//

import Foundation
import Firebase

struct Message: Codable, Identifiable {
    var id: String?
    var name: String
    var content: String
}

class MessagesViewModel: ObservableObject {
    @Published var messages = [Message]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    
    func sendMessage(messageContent: String, docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
                                                                                            "sentAt": Date(),
                                                                                            "displayName": user!.email,
                                                                                            "content": messageContent,
                                                                                            "sender": user!.uid])
        }
    }
    
    func fetchData(docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let content = data["content"] as? String ?? ""
                    let displayName = data["displayName"] as? String ?? ""
                    return Message(id: docId, name: displayName, content: content)
                }
            })
        }
    }
}
