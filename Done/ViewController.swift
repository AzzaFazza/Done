//
//  ViewController.swift
//  Done
//
//  Created by adam fallon on 22/01/2015.
//  Copyright (c) 2015 dotly. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var items = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Item")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            items = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        title = "Done"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return items.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell
            
            let item = items[indexPath.row]
            cell.textLabel!.text = item.valueForKey("itemName") as String?
            
            return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func addItem(sender: AnyObject) {
        var alert = UIAlertController(title: "New Item",
            message: "Add a new item",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                self.saveName(textField.text)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }

    func saveName(name: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Item",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        person.setValue(name, forKey: "itemName")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        items.append(person)
    }
    }

