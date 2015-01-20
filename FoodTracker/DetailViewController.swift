//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Samuel Hooker on 12/01/15.
//  Copyright (c) 2015 Jocus Interactive. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    var usdaItem:USDAItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func eatItBarButtonItemPressed(sender: AnyObject) {
    }
}
