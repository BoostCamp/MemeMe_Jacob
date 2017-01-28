//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 24..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

// MARK: - MemeCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var landscapeWidth : CGFloat = 0.0
    var portraitWidth : CGFloat = 0.0
    var memes = [Meme]()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Implement flowLayout.
        portraitWidth = self.view.frame.width
        landscapeWidth = self.view.frame.height
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memeCollectionView.reloadData();
        setupFlowLayout()
    }
    
    // MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
    
        return cell
    }
    
    
    // MARK : Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        
        controller.index = CGFloat.init(indexPath.row)
        
        self.navigationController!.pushViewController(controller, animated: true)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK : ROTATE - Portrait & Landscape
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        setupFlowLayout()
    }
    
    // configure cell size and spacing between cells
    func setupFlowLayout() {
        
        let items: CGFloat
        let space: CGFloat = 3.0
        let width: CGFloat
        if UIDevice.current.orientation.isLandscape {
            items = 5.0
            width = self.landscapeWidth
        } else {
            width = self.portraitWidth
            items = 3.0

        }
        let dimension = (width - ((items - 1) * space)) / items
        
        
        if flowLayout != nil {
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = 8.0 - items
            flowLayout.itemSize = CGSize(width: dimension,height: dimension)    
        }
     
    }

}
