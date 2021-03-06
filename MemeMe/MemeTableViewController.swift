//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {
    
    @IBOutlet weak var memeTableView: UITableView!
    
    private var memes: [Meme] {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        memeTableView.delegate = self
        memeTableView.dataSource = self
        
        setupViewInsets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        memeTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "TableDetailSegue") {
            if let selectedIndex = sender as! Int? {
                let detVc = segue.destinationViewController as! MemeDetailViewController
                detVc.selectedIndex = selectedIndex
            }
        }
    }
    
    private func setupViewInsets() {
        
        if let tabHeight = tabBarController?.tabBar.frame.size.height {
            memeTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, tabHeight, 0)
            memeTableView.contentInset = UIEdgeInsetsMake(0, 0, tabHeight, 0)
        }
    }
}

extension MemeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! MemeTableViewCell
        tableCell.memeImageView.image = memes[indexPath.row].memedImage
        tableCell.topLabel.text = memes[indexPath.row].topText
        tableCell.bottomLabel.text = memes[indexPath.row].bottomText
        
        return tableCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("TableDetailSegue", sender: indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            tableView.beginUpdates()
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
}
