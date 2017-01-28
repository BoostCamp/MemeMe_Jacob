//
//  PreviewViewController.swift
//  MemeMe
//
//  Created by Dongyoon Kang on 2017. 1. 28..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

class PreviewViewController: UICollectionViewController {
    
    //MARK : Properties
    var memes = [Meme]()
    var index : CGFloat = 0.0
    var currentIndex : CGFloat = 0.0
    
    var landscapeWidth : CGFloat = 0.0
    var portraitWidth : CGFloat = 0.0
    @IBOutlet var previewCollectionView: UICollectionView!
    @IBOutlet weak var previewFlowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        portraitWidth = self.view.frame.width
        landscapeWidth = self.view.frame.height
        
        
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToOrientationNotifications();
        
        let currentSize = self.previewCollectionView.bounds.size;
        let offset = self.index * currentSize.width;
        let point = CGPoint(x: offset, y: 0)
        previewCollectionView.setContentOffset(point, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromOrientationNotifications()
        self.navigationController?.tabBarController?.tabBar.isHidden = false

    }
    
    // MARK: Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memePreviewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
        
        return cell
    }
    
    // MARK: Collection View Event Delegate


    // MARK : ROTATE - Portrait & Landscape
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // for collectionview show smoothly
        self.previewCollectionView.alpha = 0.0
        self.previewCollectionView.layoutIfNeeded()
        let currentOffset = previewCollectionView.contentOffset
        self.currentIndex = currentOffset.x / self.previewCollectionView.frame.size.width;
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        if UIDevice.current.orientation.isLandscape {
            previewFlowLayout.itemSize = CGSize(width: self.landscapeWidth ,height: self.portraitWidth)

        } else {
            previewFlowLayout.itemSize = CGSize(width: self.portraitWidth ,height: self.landscapeWidth)
        }
        
    }
    
    func subscribeToOrientationNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(didOrientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeFromOrientationNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func didOrientationChanged(_ notification:Notification) {
        let currentSize = self.previewCollectionView.bounds.size;
        let offset = self.currentIndex * currentSize.width;
        let point = CGPoint(x: offset, y: 0)
        previewCollectionView.setContentOffset(point, animated: false)
        // for collectionview show smoothly
        UIView.animate(withDuration: 0.3, animations: {
            self.previewCollectionView.alpha = 1.0
        })
    }

    


}
