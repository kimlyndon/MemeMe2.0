//
//  SentMemesCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Kim Lyndon on 5/29/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
//Initializes meme array
    let cellIdentifier = "MemeCell"
    var memes: [Meme]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//Link to appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }

    override  func collectionView(_ _collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    
}

//MARK: Cell for item at: populates cell with array data
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
    let currentMeme = memes[indexPath.row]
    
// Set the name and image
        cell.memeImageView?.image = currentMeme.memedImage
        cell.memeTitle?.text = "\(currentMeme.topText)...\(currentMeme.bottomText)"
        cell.memeImageView.contentMode = .scaleAspectFit
    return cell
}


//MARK: Did select item at: performs a segue with selected meme
   func collectionView(_collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
// Grab the DetailVC from Storyboard
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
//Populate view controller with data from the selected item
        memeDetailController.memes = self.memes[(indexPath as NSIndexPath).row]
// Present the view controller using navigation
        self.navigationController!.pushViewController(memeDetailController, animated: true)

}

}



