//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Tantomo, Andrew | Andrew | ISDOD on 1/28/16.
//  Copyright © 2016 Andrew Tantomo. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        let applicatonDeletegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = applicatonDeletegate.memes
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        memes[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
}

