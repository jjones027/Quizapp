//
//  HomeScreenViewController.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/19/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//
//import Foundation
import UIKit

class HomeScreenViewController: UIViewController {

    
    var selectedCategory:Int? = 0
    var tableViewController:CategoriesTableTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doSegue:", name: "CategorySelected", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func doSegue(notification:NSNotification) {
    
        var userInfo = notification.userInfo!
        var index: NSIndexPath? = userInfo["index"] as? NSIndexPath
        selectedCategory = index?.row
        performSegueWithIdentifier("questionDetailSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "embedTableView" {
            self.tableViewController = segue.destinationViewController as? CategoriesTableTableViewController
            
        } else {
        let category = self.tableViewController!.categories[selectedCategory!]
        var destination = segue.destinationViewController as DetailViewController
        destination.category = category
        
        }
    }
    
}