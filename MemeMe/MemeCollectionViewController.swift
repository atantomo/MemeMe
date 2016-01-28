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
    
    let itemSpacer: CGFloat = 8.0
    
    let portraitItemCount: CGFloat = 3.0
    let landscapeItemCount: CGFloat = 5.0
    
    var itemCount: CGFloat{
        get {
            switch (UIDevice.currentDevice().orientation) {
            case .Portrait, .PortraitUpsideDown:
                return portraitItemCount
            case .LandscapeLeft, .LandscapeRight:
                return landscapeItemCount
            default:
                return portraitItemCount
            }
        }
    }
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        
        memeCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, (tabBarController?.tabBar.frame.size.height)!, 0)
        memeCollectionView.contentInset = UIEdgeInsetsMake(itemSpacer, itemSpacer, (tabBarController?.tabBar.frame.size.height)!, itemSpacer)
        
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        recalculateItemDimension()
    }
    
    private func recalculateItemDimension() {

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
        performSegueWithIdentifier("CollectionDetailSegue", sender: collectionView)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}

