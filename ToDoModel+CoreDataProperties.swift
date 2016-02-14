//
//  ToDoModel+CoreDataProperties.swift
//  BitList-AllNew
//
//  Created by Abraham Sidabutar on 1/6/16.
//  Copyright © 2016 Abraham Sidabutar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToDoModel {

    @NSManaged var title: String?
    @NSManaged var repeated: NSNumber?
    @NSManaged var reminder: NSDate?
    @NSManaged var favourited: NSNumber?
    @NSManaged var dueDate: NSDate?
    @NSManaged var section: String?

}
