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
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pugs: [PLPug] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadMorePugs() {
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pugs.count - 1 {
            loadMorePugs() {}
        }
    }
}
















