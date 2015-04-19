//
//  DetailViewController.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/14/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //Create json & category properties
    var json: JSON = []
    var subcategory: Subcategory?

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.subcategory?.category {
            if let name = category.name {
                self.categoryLabel.text = name
            }
        }
        
        if let subcategory = self.subcategory {
            if let image = subcategory.image {
                println("detail cat image: \(image)")
                albumImage.image = UIImage(named: image)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonPress(sender: AnyObject) {
        let answer = answerText.text
        println("answer text: \(answer)")
        
        if (answer.lowercaseString == subcategory?.name?.lowercaseString) {
            println("Correct answer")
            let alertController = UIAlertController(title: "Answer Status", message:
                "You are correct!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            println("Negative ghostrider")
            let alertController = UIAlertController(title: "Answer Status", message:
                "Incorrect, try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
