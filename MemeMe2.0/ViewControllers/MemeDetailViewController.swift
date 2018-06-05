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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemeDetailImageView.image = memes.memedImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
}
