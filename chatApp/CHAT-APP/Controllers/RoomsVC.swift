//
//  RoomsVC.swift
//  CHAT-APP
//
//  Created by MAC on 2/2/2012 ERA1.
//  Copyright © 2012 ERA1 mamdouh. All rights reserved.
//

import UIKit
import Firebase
class RoomsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomTable: UITableView!
    
    var rooms = [Room]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTable.delegate = self
        roomTable.dataSource  = self

        
        roomObserv()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            presentLoginScreen()
        }
        
    }
    
    func roomObserv(){
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            
            if let dataArray = snapshot.value  as? [String: Any]{
                if let roomName = dataArray["roomName"] as? String{
                   let room = Room.init(roomId: snapshot.key, roomName: roomName)
                    self.rooms.append(room)
                    
                   self.roomTable.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func didPressLogout(_ sender: UIBarButtonItem) {
      try! Auth.auth().signOut()
        presentLoginScreen()
    }
    
    @IBAction func didPressedCreatRoom(_ sender: UIButton) {
        
        guard  let roomName = roomNameTextField.text, roomNameTextField.text?.isEmpty == false else{
            return
        }
        
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        
        let dataArray:[String: Any] = ["roomName": roomName]
        
        
        room.setValue(dataArray) { (error, ref) in
            
         if (error == nil){
                self.roomNameTextField.text = ""
            }
        }
        
    }
    
    func presentLoginScreen(){
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginScreen") as! FormVC
        
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRoom = rooms[indexPath.row]
        
        let chatRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomsVC
        
        chatRoomVC.room = selectedRoom
        
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
        
 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let room = self.rooms[indexPath.row]
        let cell = roomTable.dequeueReusableCell(withIdentifier: "roomCell")!
        
        cell.textLabel?.text = room.roomName
        return cell
        
    }
    

}
