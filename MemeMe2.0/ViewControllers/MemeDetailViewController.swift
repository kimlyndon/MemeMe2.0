//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Kim Lyndon on 5/29/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var memes: Meme!
    
    @IBOutlet weak var sentMemeDetailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailViewController.startMemeEditor))
        sentMemeDetailImageView.image = memes.memedImage
        self.tabBarController?.tabBar.isHidden = true
    
}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @objc func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorVC, animated: true, completion: nil)
        
        memeEditorVC.topTextField.text = memes.topText
        memeEditorVC.bottomTextField.text = memes.bottomText
        memeEditorVC.imagePickerView.image = memes.originalImage
        memeEditorVC.isEditing = true
    }
    }

