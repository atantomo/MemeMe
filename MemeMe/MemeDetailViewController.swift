//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var memeHeightConstraint: NSLayoutConstraint!
    
    private var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editButtonTapped:")
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let index = selectedIndex {
            memeImageView.image = memes[index].memedImage
            setMemeImageLayout(memes[index].image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailEditSegue") {
            let editVc = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! MemeEditorViewController
            editVc.selectedIndex = selectedIndex
        }
    }
    
    func editButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("DetailEditSegue", sender: self)
    }
    
    private func setMemeImageLayout(memeImage: UIImage) {
        
        let mW = memeImage.size.width
        let mH = memeImage.size.height
        let cW = canvasView.frame.size.width
        let cH = canvasView.frame.size.height
        
        // if orientation is portrait and meme is landscape, set meme width to canvas'
        // (similar to UIImage's aspect fit behavior)
        if (cH / cW > mH / mW) {
            memeWidthConstraint.constant = canvasView.frame.size.width
            memeHeightConstraint.constant = canvasView.frame.size.width * (mH / mW)
        } else {
            // otherwise, set meme height to canvas'
            memeHeightConstraint.constant = canvasView.frame.size.height
            memeWidthConstraint.constant = canvasView.frame.size.height * (mW / mH)
        }
    }
}
