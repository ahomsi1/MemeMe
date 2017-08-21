//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Amer Homsi on 8/16/17.
//  Copyright © 2017 Amer Homsi. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCellIdentifier")
        let memes = self.memes[(indexPath as NSIndexPath).row]
        
        cell?.textLabel?.text = "\(memes.topText) \(memes.bottomText)"
        cell?.imageView?.image = memes.memedImage
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.memes = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memeDetailVC, animated: true)
    }
    
}
