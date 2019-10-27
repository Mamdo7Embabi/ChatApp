//
//  ChatCell.swift
//  CHAT-APP
//
//  Created by MAC on 2/10/2012 ERA1.
//  Copyright © 2012 ERA1 mamdouh. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    enum BubbleType{
        case Incoming
        case Outgoing
    }
    
    
    @IBOutlet weak var chatBubble: UIView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatBubble.layer.cornerRadius = 7
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func messageData(message:Message){
        userNameLabel.text = message.senderName
        chatTextView.text = message.senderMessage
    }

    func setBubbleType(type:BubbleType){
        if (type == .Incoming){
            chatStack.alignment = .leading
            chatBubble.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
        }else if (type == .Outgoing){
            chatStack.alignment  = .trailing
            chatBubble.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
    }
}
