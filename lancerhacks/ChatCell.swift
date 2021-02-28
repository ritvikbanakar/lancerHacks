//
//  ChatCell.swift
//  lancerhacks
//
//  Created by Sid on 2/27/21.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var otherTV: UITextView!
    @IBOutlet weak var myTV: UITextView!
    
    func set_text(text: String, me: Bool){
        if(me){
            self.myTV.text = text
            self.otherTV.text = ""
        } else {
            self.myTV.text = ""
            self.otherTV.text = text
        }
    }

}
