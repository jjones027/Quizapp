//
//  CategoriesTableTableViewController.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/14/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

class CategoriesTableTableViewController: UITableViewController {
    
    //Create categories array
    var categories = [Category] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add footer view to remove extra rows in table
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Retrieve the category name from JSON file using SwiftyJSON & add to category array
        if let path = NSBundle.mainBundle().pathForResource("categories", ofType: "json") {
            if let data = NSData(contentsOfMappedFile: path) {
                var error: NSError? = nil
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: &error)
                if error != nil {
                    println(error?.description)
                }
                for i in 0...json["category"].count {
                    if let jsonCategoryName = json["category"][i].string{
                        if let album = json[jsonCategoryName]["album"].string{
                            println("subcategory: \(album)")}
                       let categoryName = Category(name: jsonCategoryName)
                       self.categories.append(categoryName)
                    }
                }
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // When user selects table row post notification & indexPath -listen for notification within HomeScreenViewController
        NSNotificationCenter.defaultCenter().postNotificationName("CategorySelected", object: nil, userInfo:["index": indexPath])
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return  self.categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as CategoryCell

        // Populate the table cells with Category name
        let category = self.categories[indexPath.row]
        cell.categoryLabel.text = category.name
        cell.lockImageView.image = UIImage(named: "unlocked")
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
