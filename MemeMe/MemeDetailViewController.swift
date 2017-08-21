//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Amer Homsi on 8/20/17.
//  Copyright © 2017 Amer Homsi. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var memes: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.memeImageView!.image = memes.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
