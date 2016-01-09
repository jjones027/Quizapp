//
//  SubCategoryViewController.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/25/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

let reuseIdentifier = "SubCategoryCell"

class SubCategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    //Create json & category properties, subcategory array
    var json: JSON = []
    var category: Category?
    var subcategories = [Subcategory] ()
    var correctAlbums:[NSString] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(AlbumImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let categoryName = self.category?.name
        
        // Filter the json object only for images associated with the category
        for i in 0...json[(categoryName)!].count {
                if let image = json[(categoryName)!][i]["Image"].string {
                    print("image: \(image)")
                    let subcategory = Subcategory(name: json[(categoryName)!][i]["album"].string,image: image, category: self.category)
                    self.subcategories.append(subcategory)
                }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Pass selected category to the subcategory view controller
        let cell = sender as! AlbumImageCell
        let indexpath = self.collectionView?.indexPathForCell(cell)
        
        let destination = segue.destinationViewController as! DetailViewController
        
        destination.subcategory = self.subcategories[indexpath!.item]
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return json[self.category!.name!].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Set cell to the subclassed UICollectionViewCell as AlbumImageCell
        let cell: AlbumImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlbumImageCell
        
        // Check if user has guessed album correctly then change opacity 
        cell.backgroundColor = UIColor.whiteColor()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedArray = defaults.objectForKey("correctAlbums") {
            correctAlbums = savedArray as! [NSString]
            if correctAlbums.contains(json[self.category!.name!][indexPath.item]["album"].string!) {
                cell.albumImageView.alpha = 0.3
            }
        }
        
        //Set the imageview as the cover image
        if let image = json[self.category!.name!][indexPath.item]["Image"].string {
            cell.albumImageView.image = UIImage(named: image)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Need math - self.view.frame - will be size of the screen
      //  self.view.frame.size
        return CGSizeMake(105, 105)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
