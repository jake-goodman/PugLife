//
//  PLCollectionViewController.swift
//  PugLife
//
//  Created by Jake Goodman on 9/20/18.
//  Copyright © 2018 Jake Goodman. All rights reserved.
//

import UIKit
import Kingfisher

class PLCollectionViewController: UIViewController {

    fileprivate enum Constants {
        static let collectionViewPadding: CGFloat = 2
        static let collectionViewNumberToFit: CGFloat = 3
        static let collectionViewPlaceholderImage: UIImage = #imageLiteral(resourceName: "pug-placeholder")
        
        static let clipboardTextSuccess: String = "Copied to Clipboard"
        static let clipboardTextError: String = "Error Copying Image"
        static let clipboardAnimationDuration: Double  = 0.33
        static let clipboardDisplayDuration: Double  = 1.0
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clipboardAlertLabel: UILabel!
    
    var pugs: [PLPug] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PLCollectionViewController.handleLongPressGesture(_:)))
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        clipboardAlertLabel.alpha = 0
        clipboardAlertLabel.layer.cornerRadius = 12
        
        loadMorePugs() {
            
        }
    }

    func loadMorePugs(completion: @escaping ()->Void) {
        PugService().getPugs() { [weak self] (pugs, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load more pugs. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            else {
                self?.pugs.append(contentsOf: pugs)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    @objc func handleLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }

        let point = recognizer.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: point), let cell = self.collectionView.cellForItem(at: indexPath) as? PLImageCollectionViewCell {
            
            if let image = cell.imageView.image {
                UIPasteboard.general.image = image
                clipboardAlertLabel.text = Constants.clipboardTextSuccess
            }
            else {
                clipboardAlertLabel.text = Constants.clipboardTextError
            }
            
            let fadeInBlock: ()->Void = { self.clipboardAlertLabel.alpha = 1.0 }
            let fadeOutBlock: (Bool)->Void = { [weak self] (completed) in
                UIView.animate(withDuration: Constants.clipboardAnimationDuration,
                               delay: Constants.clipboardDisplayDuration,
                               options: UIViewAnimationOptions.curveEaseInOut,
                               animations: {self?.clipboardAlertLabel.alpha = 0},
                               completion: nil)
            }
            UIView.animate(withDuration: Constants.clipboardAnimationDuration,
                           animations: fadeInBlock,
                           completion: fadeOutBlock)
        }
    }
}

extension PLCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pugs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? PLImageCollectionViewCell else { return UICollectionViewCell() }
        
        let pug = pugs[indexPath.row]
        cell.imageView.kf.setImage(with: pug.imageUrl, placeholder: Constants.collectionViewPlaceholderImage)
        return cell
    }
}

extension PLCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = Constants.collectionViewPadding
        let numToFit = Constants.collectionViewNumberToFit
        let minDimension = min(collectionView.bounds.width, collectionView.bounds.height)
        
        let itemWidth = ((minDimension - ( (numToFit - 1) * padding)) / numToFit)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let imageVC = storyboard.instantiateViewController(withIdentifier: "PLImageViewController") as? PLImageViewController else  { return }
        
        let pug = self.pugs[indexPath.row]
        imageVC.resource = pug.imageUrl
        present(imageVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pugs.count - 1 {
            loadMorePugs() {}
        }
    }
}
















