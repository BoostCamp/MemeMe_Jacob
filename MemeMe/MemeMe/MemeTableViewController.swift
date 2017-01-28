//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 24..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK : Properties
    @IBOutlet weak var memeTableView: UITableView!
    
    var memes = [Meme]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK : Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memeTableView.reloadData();
    }

    // MARK : TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeTableViewCell
        
        let meme = self.memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        var topText = meme.topText
        var bottomText = meme.bottomText
        if meme.topText.isEmpty {
            topText = "TOP"
        }
        
        if meme.bottomText.isEmpty {
            bottomText = "BOTTOM"
        }
        cell.memedLabel.text = "\(topText)...\(bottomText)"
        
        return cell
    }
    
    // MARK : TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // navigate previewViewController
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.index = CGFloat.init(indexPath.row)
    
        navigationController!.pushViewController(controller, animated: true)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
}

