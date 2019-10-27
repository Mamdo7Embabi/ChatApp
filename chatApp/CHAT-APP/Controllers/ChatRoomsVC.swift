//
//  ChatRoomsVC.swift
//  CHAT-APP
//
//  Created by MAC on 2/3/2012 ERA1.
//  Copyright © 2012 ERA1 mamdouh. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomsVC: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    var room:Room?
    var chatMessages = [Message]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = room?.roomName
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observMessages()
    }
    
    func getUserNameById(id: String, complition:@escaping (_ userName: String?)->()){
        let databaseRef = Database.database().reference()
        
        let user = databaseRef.child("users").child(id)
        
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String{
                
                complition(userName)
            }else{
                complition(nil)
            }
    }
        
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func observMessages(){
        
        guard let userId = room?.roomId  else {return}
        let databaseRef = Database.database().reference()
        
        databaseRef.child("rooms").child(userId).child("messages").observe(.childAdded) { (snapshot) in
            
            if let dataArray = snapshot.value as? [String: Any]{
                
                guard let sender = dataArray["sender"] as? String, let text = dataArray["txt"]  as? String, let userId = dataArray["userId"] as? String else {return}
                
             let message = Message.init(messageKey: snapshot.key, senderName: sender, senderMessage: text, userId: userId)
                
                
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
                self.scrollToBottom()
                
            }
            
        }
        
    }
    
    func sendMessage(text:String , complition:@escaping (_ isSuccess: Bool)->()){
        
        guard let userId = Auth.auth().currentUser?.uid  else{
            return
        }
      
        let databaseRef = Database.database().reference()
        getUserNameById(id: userId) { (userName) in
            if let userName  = userName{
            if let roomId = self.room?.roomId, let userId = Auth.auth().currentUser?.uid{
                
                let  dataArray:[String:Any] = ["sender": userName,"txt":text,"userId":userId]
                
                let room = databaseRef.child("rooms").child(roomId)
                
                room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                    
                    if error == nil{
                        complition(true)
                    }else{
                        complition(false)
                    }
                })
                
            }
        }
    }
        
}

    
    @IBAction func didPressedSendBtn(_ sender: UIButton) {
        
        guard let chatMessege = chatTextField.text , chatTextField.text?.isEmpty == false  else{
            return
        }
        
        sendMessage(text: chatMessege) { (isSucess) in
            if(isSucess){
                print("Message Send")
                self.chatTextField.text = ""
            }
        }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        let messageIndex = self.chatMessages[indexPath.row]
        
        cell.messageData(message: messageIndex)
       
         let currentUser = Auth.auth().currentUser?.uid
        
        if (messageIndex.userId == currentUser){
            cell.setBubbleType(type: .Outgoing)
        }else{
            cell.setBubbleType(type: .Incoming)
        }
        
        return cell
    }
    
}

