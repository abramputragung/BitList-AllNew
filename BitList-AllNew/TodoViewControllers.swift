//
//  TodoViewControllers.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 1/4/16.
//  Copyright © 2016 Abraham Sidabutar. All rights reserved.
//

import UIKit
import CoreData

class TodoViewControllers: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todo: ToDoModel!
    
    var currentMenuView: UIView?
    
    var context: NSManagedObjectContext?
    
    @IBOutlet var datePickerView: DatePickerView!
    
    @IBOutlet var repeatPickerView: RepeatView!
    
    @IBOutlet var reminderPickerView: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if todo.section == "pending" {
            navigationItem.leftBarButtonItem?.title = "Complete"
        }
        else {
            navigationItem.leftBarButtonItem?.title = "Pending"
        }
        
        if todo.favourited != nil {
            navigationItem.rightBarButtonItem?.title = "Unfavorite"
        }
        
        navigationItem.title = todo.title
        
        let swipeView = UISwipeGestureRecognizer(target: self, action: "respondToSwipe")
        swipeView.direction = UISwipeGestureRecognizerDirection.Right
        
        navigationController?.navigationBar.addGestureRecognizer(swipeView)
        
        let secondSwipeView = UISwipeGestureRecognizer(target: self, action: "respondToSwipe")
        secondSwipeView.direction = UISwipeGestureRecognizerDirection.Right
        tableView.addGestureRecognizer(secondSwipeView)
        
        datePickerView.frame = CGRectMake(view.frame.origin.x, view.frame.height, view.frame.size.width, datePickerView.frame.height)
        datePickerView.delegate = self
        view.addSubview(datePickerView)
        
        repeatPickerView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height, view.frame.size.width, datePickerView.frame.height)
        repeatPickerView.delegate = self
        view.addSubview(repeatPickerView)
        
        reminderPickerView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height, view.frame.size.width, reminderPickerView.frame.height)
        reminderPickerView.delegate = self
        view.addSubview(reminderPickerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipe(gesture: UISwipeGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func completeBarButtonItemPressed(sender: UIBarButtonItem) {
        
        if todo.section == "pending"{
            todo.section = "completed"
        }
        else {
             todo.section = "pending"
        }
        navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func favoriteBarButtonItemPressed(sender: UIBarButtonItem) {
       
        if todo.favourited != nil {
            navigationItem.rightBarButtonItem?.title = "Unfavorite"
            todo.favourited = nil
        }
        else {
            navigationItem.rightBarButtonItem?.title = "Favorite"
            todo.favourited = 1
        }
        
    }
    
    @IBAction func deleteBarButtonItemPressed(sender: UIBarButtonItem) {
        
        if let object = todo, context = context {
            context.deleteObject(object)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func presentPicker (menuView: UIView) {
        
        currentMenuView = menuView
        
        UIView.animateWithDuration(0.6) { () -> Void in
            menuView.frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y - menuView.frame.size.height,menuView.frame.width, menuView.frame.size.height)
        }
    }
    
    func dismissPicker() {
        UIView.animateWithDuration(1.0) { () -> Void in
            if let picker = self.currentMenuView {
                self.currentMenuView = nil
                picker.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, picker.frame.height)
            }
        }
    }
}

extension TodoViewControllers: RepeatViewDelegate {
    func remove() {
        dismissPicker()
        todo.repeated = nil
        tableView.reloadData()
    }
    
    func done() {
        dismissPicker()
    }
    
    func pickerViewDidSelect(type: RepeatType) {
        todo.repeated = type.rawValue
        tableView.reloadData()
    }
}

extension TodoViewControllers: DatePickerViewDelegate {
    func removePressed() {
        if let menuView = currentMenuView {
            if menuView == datePickerView {
                todo.dueDate = nil
            }
            else if menuView == reminderPickerView{
                todo.reminder = nil
            }
        }
        dismissPicker()
        tableView.reloadData()
    }
    
    func donePressed() {
        dismissPicker()
    }
    
    func datePickerValueChanged(date: NSDate) {
        if let menuView = currentMenuView {
            if menuView == datePickerView {
                todo.dueDate = date
            }
            else if menuView == reminderPickerView{
                todo.reminder = date
            }
        }
        tableView.reloadData()
    }
}

extension TodoViewControllers: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentMenu = currentMenuView
        
        dismissPicker()
        
        var pickerView: UIView?
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pickerView = datePickerView
        case (0,1):
            pickerView = repeatPickerView
        case (1,0):
            pickerView = reminderPickerView
        default: break
        }
        
        if let viewforPicker = pickerView where currentMenu != pickerView {
            presentPicker(viewforPicker)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
}

extension TodoViewControllers: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        let timeStringFormatter = NSDateFormatter()
        timeStringFormatter.dateFormat = "HH:mm:ss"
        
        if indexPath.section == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
            
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "calendar")
                
                if let dueDate = todo.dueDate {
                    let dateString = dateStringFormatter.stringFromDate(dueDate)
                    
                    cell.textLabel?.text = "Due " + dateString
                    cell.textLabel?.textColor = UIColor.blueColor()
                    cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
                }
                else {
                    cell.textLabel?.text = "Due Date"
                    cell.textLabel?.textColor = UIColor.lightGrayColor()
                }
            }
            else {
               cell.imageView?.image = UIImage(named: "repeat")
                
                if let repeatFrequency = todo.repeated, repeatedName = RepeatType(rawValue: Int(repeatFrequency)) {
                    cell.textLabel?.text = "Repeat \(repeatedName)"
                    cell .textLabel?.textColor = UIColor.blueColor()
                    cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
                }
                else {
                    cell.textLabel?.text = "Repeat"
                    cell.textLabel?.textColor = UIColor.lightGrayColor()
                }
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Reminder")!
            
            cell.imageView?.image = UIImage(named:  "alarmclock")
            
            if let reminderDate = todo.reminder {
                let timeString = timeStringFormatter.stringFromDate(reminderDate)
                
                cell.textLabel?.text = "Remind me at " + timeString
                cell.textLabel?.textColor = UIColor.blueColor()
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
                
                let dateString = dateStringFormatter.stringFromDate(reminderDate)
                
                cell.detailTextLabel?.text = dateString
            }
            else {
                cell.textLabel?.text = "Reminder"
                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.detailTextLabel?.text = ""
            }
            return cell
            
        }
        
        
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1{
            return 1
        }
        
        return 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
}