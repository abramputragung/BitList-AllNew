//
//  ToDoTableViewCell.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 12/29/15.
//  Copyright © 2015 Abraham Sidabutar. All rights reserved.
//

import UIKit

protocol ToDoTableViewCellDelegate {
    func CompleteToDo(cell: ToDoTableViewCell)
    func favouriteToDo(cell: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var completedButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var indexPath : NSIndexPath!
    
    var delegate: ToDoTableViewCellDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func completeButtonTapped(sender: UIButton) {
        delegate?.CompleteToDo(self)
        
    }
    
    @IBAction func favouriteButtonTapped(sender: UIButton) {
        delegate?.favouriteToDo(self)
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            dateLabel.hidden = true
            completedButton.hidden = true
            favouriteButton.hidden = true
        }
        else {
            dateLabel.hidden = false
            completedButton.hidden = false
            favouriteButton.hidden = false
        }
    }
    
}
