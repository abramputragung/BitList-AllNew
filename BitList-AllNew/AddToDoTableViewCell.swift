//
//  AddToDoTableViewCell.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 12/29/15.
//  Copyright © 2015 Abraham Sidabutar. All rights reserved.
//

import UIKit

class AddToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var addTodoTextField: UITextField!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    var favourited: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // favouriteButton.backgroundColor = UIColor.orangeColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouriteButtonTapped(sender: UIButton) {
        
        if addTodoTextField.isFirstResponder() {
            favourited = !favourited
            
            if favourited {
                favouriteButton.backgroundColor = UIColor.blueColor()
            }
            else {
                favouriteButton.backgroundColor = UIColor.orangeColor()
            }
            
        }
        
    }


}
