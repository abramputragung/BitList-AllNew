//
//  ToDoViewController.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 12/29/15.
//  Copyright © 2015 Abraham Sidabutar. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var baseArray: [[ToDoModel]] = []
    
    var selectedTodoIndexPath: NSIndexPath!
    
    var context: NSManagedObjectContext?
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.backgroundColor = UIColor.clearColor()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressRecognized:")
        
        gestureRecognizer.minimumPressDuration = 1.0
        
        tableView.addGestureRecognizer(gestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let createNewItem: AddToDoTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddToDoCell") as! AddToDoTableViewCell
        createNewItem.backgroundColor = UIColor(red: 208/255, green: 198/255, blue: 177/255, alpha: 0.7)
        createNewItem.favouriteButton.backgroundColor = UIColor.orangeColor()
        
        tableView.tableHeaderView = UIView.init(frame:createNewItem.frame)
        tableView.tableHeaderView?.addSubview(createNewItem)
        
        if let context = context {
            let request = NSFetchRequest(entityName: "ToDoModel")
            let dateSort = NSSortDescriptor(key: "dueDate", ascending: true)
            let sectionSort = NSSortDescriptor(key: "section", ascending: false)
            request.sortDescriptors = [sectionSort, dateSort]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "section", cacheName: "AllToDos")
            
            fetchedResultsController?.delegate = self
            
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("There was a problem fetching")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "todosToTodoSegue" {
            let indexpath = sender as! NSIndexPath
            let selectedTodo = fetchedResultsController?.objectAtIndexPath(indexpath) as! ToDoModel
            
            let todoViewController = segue.destinationViewController as! TodoViewControllers
            todoViewController.context = context
            todoViewController.todo = selectedTodo
        }
    }
    
    @IBAction func editBarButtonItemTapped(sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            if tableView.editing {
                tableView.setEditing(false, animated: true)
            }
            else {
                tableView.setEditing(true, animated: true)
            }
        }
        else if sender.title == "Done" {
            
            let addToDoTableViewCell = tableView.tableHeaderView?.subviews.first as! AddToDoTableViewCell
            if addToDoTableViewCell.addTodoTextField.text != "" {
                
                guard let context = context else { return }
                
                guard let todo = NSEntityDescription.insertNewObjectForEntityForName("ToDoModel", inManagedObjectContext: context) as? ToDoModel else { return }
                
                todo.title = addToDoTableViewCell.addTodoTextField.text!
                
                addToDoTableViewCell.addTodoTextField.text = ""
                addToDoTableViewCell.addTodoTextField.resignFirstResponder()
            }
            else {
                let alert = UIAlertController(title: "Invalid ToDo", message: "Please enter a title before adding a ToDo", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func longPressRecognized (gestureRecognizer: UILongPressGestureRecognizer){
        if !tableView.editing {
            tableView.editing = true
        }
    }
    
    //: MARK - Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        navigationItem.rightBarButtonItem?.title = "Done"
    }
    
    func keyboardWillHide(notification: NSNotification) {
        navigationItem.rightBarButtonItem?.title = "Edit"
    }
    
}

extension ToDoViewController: ToDoTableViewCellDelegate {
    func CompleteToDo(cell: ToDoTableViewCell) {
        
        let indexPath = tableView.indexPathForCell(cell)
        
        print("Complete Todo at IndexPath:", indexPath)
        
        guard let selectedTodo = fetchedResultsController?.objectAtIndexPath(indexPath!) as? ToDoModel else { return }
        
        print("Section was", selectedTodo.section)
        
        if selectedTodo.section == "pending" {
            selectedTodo.section = "completed"
        }
        else {
            selectedTodo.section = "pending"
        }
        print("Now section is:", selectedTodo.section!)
        
    }
    
    func favouriteToDo(cell: ToDoTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        guard let selectedTodo = fetchedResultsController?.objectAtIndexPath(indexPath!) as? ToDoModel else { return }
        if selectedTodo.favourited == 1 {
            selectedTodo.favourited = nil
        }
        else {
            selectedTodo.favourited = 1
        }
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("todosToTodoSegue", sender: indexPath)
        selectedTodoIndexPath = indexPath
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        
        return 25
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing {
            return UITableViewCellEditingStyle.None
        }
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let currentToDo = baseArray[0][sourceIndexPath.row]
        
        baseArray[0].removeAtIndex(sourceIndexPath.row)
        baseArray[0].insert(currentToDo, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let object = fetchedResultsController?.objectAtIndexPath(indexPath) as? ToDoModel, context = context {
                context.deleteObject(object)
                
                // Note: table updates and saves to Core Data are now handled by the NSFetchedResultsControllerDelegate methods below
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ToDoTableViewCell = tableView.dequeueReusableCellWithIdentifier("ToDoCell") as! ToDoTableViewCell
        
        guard let currentToDo = fetchedResultsController?.objectAtIndexPath(indexPath) as? ToDoModel else { return cell }
        
        cell.titleLabel.text = currentToDo.title
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = currentToDo.dueDate {
            let dateString = dateStringFormatter.stringFromDate(date)
            cell.dateLabel.text = dateString
        }
        
        if currentToDo.section == "pending" {
            cell.completedButton.backgroundColor = UIColor.redColor()
        }
        else {
            cell.completedButton.backgroundColor = UIColor.greenColor()
        }
        
        if currentToDo.favourited != nil {
            cell.favouriteButton.backgroundColor = UIColor.blueColor()
        }
        else {
            cell.favouriteButton.backgroundColor = UIColor.orangeColor()
        }
        
        cell.backgroundColor = UIColor(red: 235/255, green: 176/255, blue: 53/255, alpha: 0.7)
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController?.sections else { return 0 }
        
        let currentSection = sections[section]
        
        return currentSection.numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultsController?.sections else  { return "" }
        let currentSection = sections[section]
        
        return "\(currentSection.name.capitalizedString)"
    
    }
}

extension ToDoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        do {
            try context!.save()
        } catch {
            print("There was an error saving to Core Data")
        }
        tableView.endUpdates()
    }
    
}








