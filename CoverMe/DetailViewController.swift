//
//  DetailViewController.swift
//  CoverMe
//
//  Created by Jeffrey Jones on 3/14/15.
//  Copyright (c) 2015 Electric City Studios. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,WordPuzzleDelegate {
    
    //Create subcategory, puzzle & score properties
    var subcategory: Subcategory?
    var puzzle: WordPuzzle? = nil
    var score = 0
    var newScore = 0
    var correctAlbums:[NSString] = []
    
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the correct answer label
        correctAnswerLabel.hidden = true
        
        // Set score label
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.valueForKey("score") != nil) {
            score = defaults.valueForKey("score") as! NSInteger!
            scoreLabel.text = NSString(format: "Score: %i", score) as String
        }
        
        // Set category label
        if let category = self.subcategory?.category {
            if let name = category.name {
                self.categoryLabel.text = name
            }
        }
        
        // Set album image
        if let subcategory = self.subcategory {
            if let image = subcategory.image {
                print("detail cat image: \(image)")
                albumImage.image = UIImage(named: image)
            }
        }

        // Create puzzle object, answer and question grids if question isn't solved. If solved display label with answer.
        if (defaults.valueForKey("correctAlbums") == nil) {
            print("correct album defaults is nil")
            defaults.setObject(correctAlbums, forKey: "correctAlbums")
            defaults.synchronize()
        }
        
        if let savedArray = defaults.objectForKey("correctAlbums") {
            correctAlbums = savedArray as! [NSString]
            if correctAlbums.contains(subcategory!.name!) {
                print("Don't display puzzle grids")
                correctAnswerLabel.hidden = false
                correctAnswerLabel.numberOfLines = 0
                correctAnswerLabel.text = "Album guessed correctly. \n Answer = \(subcategory!.name!)"
            }
            else {
                print("display puzzle grid")
                self.puzzle = WordPuzzle(word: subcategory?.name! , andRandomCharacterToInjectCount: 4)
                self.puzzle?.delegate = self
                self.puzzle?.addQuestionButtonsGridWithFrame(CGPointMake(20, 240), showOn: self.view)
                self.puzzle?.addAnswerGridWithFrame(CGPointMake(20, 380), showOn: self.view)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishSolvingPuzzle() {
        
        // Update the score in the NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.valueForKey("score") != nil) {
            score = defaults.valueForKey("score") as! Int
        }
        newScore = score + 10
        defaults.setInteger(newScore, forKey: "score")
        
        // Check if list of correct albums has been saved to defaults, then append
        if let savedArray = defaults.objectForKey("correctAlbums") {
            correctAlbums = savedArray as! [NSString]
            correctAlbums.append((subcategory?.name)!)
        } else {
            correctAlbums.append((subcategory?.name)!)
        }
        
        // Update the defaults with correct album array and synch
        print("list of correct albums: \(correctAlbums)")
        defaults.setObject(correctAlbums, forKey: "correctAlbums")
        defaults.synchronize()
        
        // Display alert when user solves puzzle and navigate back to previous controller
        let alertController = UIAlertController(title: "Answer Status", message:
            "You are correct!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: {action in self.navigationController?.popViewControllerAnimated(true)
            return}))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didFailSolvingPuzzle() {
        
        
        // Display alert when user solves puzzle incorrectly
        let alertController = UIAlertController(title: "Answer Status", message:
            "You are incorrect!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: {action in }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
/*    @IBAction func submitButtonPress(sender: AnyObject) {
        let answer = answerText.text
        println("answer text: \(answer)")
        
        if (answer.lowercaseString == subcategory?.name?.lowercaseString) {
            println("Correct answer")
            let alertController = UIAlertController(title: "Answer Status", message:
                "You are correct!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: {action in self.navigationController?.popViewControllerAnimated(true)
                return}))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            println("Negative ghostrider")
            let alertController = UIAlertController(title: "Answer Status", message:
                "Incorrect, try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    } */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
