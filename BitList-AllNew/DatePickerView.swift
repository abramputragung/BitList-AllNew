//
//  DatePickerView.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 1/5/16.
//  Copyright © 2016 Abraham Sidabutar. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate {
    func removePressed()
    func donePressed()
    func datePickerValueChanged(date: NSDate)
}


class DatePickerView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: DatePickerViewDelegate?
    
    @IBAction func removeBarButtonItemPressed(sender: UIBarButtonItem) {
        delegate?.removePressed()
        
    }

    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        delegate?.donePressed()
        
    }

    @IBAction func datePickerChanged(sender: UIDatePicker) {
        delegate?.datePickerValueChanged(sender.date)
        
    }

}
