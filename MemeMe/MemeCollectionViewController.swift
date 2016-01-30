//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    private let itemSpacer: CGFloat = 8.0
    
    private let portraitItemCount: CGFloat = 3.0
    private let landscapeItemCount: CGFloat = 5.0
    
    private var itemCount: CGFloat{
        get {
            let h = view.frame.size.height
            let w = view.frame.size.width
            return h > w ? portraitItemCount : landscapeItemCount
        }
    }
    
    private var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        
        setupViewInsets()
        recalculateItemDimension()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        memeCollectionView.reloadData()
        recalculateItemDimension()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        recalculateItemDimension()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CollectionDetailSegue") {
            if let selectedIndex = sender as! Int? {
                let detVc = segue.destinationViewController as! MemeDetailViewController
                detVc.selectedIndex = selectedIndex
            }
        }
    }
    
    private func setupViewInsets() {
        
        var tabInset: CGFloat = 0.0
        if let tabHeight = tabBarController?.tabBar.frame.size.height {
            tabInset = tabHeight
        }
        memeCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, tabInset, 0)
        memeCollectionView.contentInset = UIEdgeInsetsMake(itemSpacer, itemSpacer, tabInset + itemSpacer, itemSpacer)
    }
    
    private func recalculateItemDimension() {
        
        // add spacing in between items and at both left/right ends
        let dimension = (self.view.frame.size.width - ((itemCount + 1) * itemSpacer)) / itemCount
        flowLayout.minimumLineSpacing = itemSpacer
        flowLayout.minimumInteritemSpacing = itemSpacer
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
}

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        collectionCell.memeImageView.image = memes[indexPath.row].memedImage
        return collectionCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("CollectionDetailSegue", sender: indexPath.item)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
}

