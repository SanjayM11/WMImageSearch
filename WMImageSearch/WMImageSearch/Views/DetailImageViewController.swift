//
//  DetailImageViewController.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 16/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var list: [ImageModel] = []
    var index: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //collectionView.reloadData()
        let indexPath = IndexPath.init(row: self.index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
    }
    
    func initializeWithList(_ list: [ImageModel], index:Int){
        self.list = list
        self.index = index
    }
    
    @IBAction func onBackBtnTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier.kDIVCCollectionCellReuseId,
                                                      for: indexPath) as! DetailImageCollectionViewCell
        let object = list[indexPath.row]
        cell.imageView.imageFromServerURL(urlString: object.largeImageURL)
        return cell
    }
}

extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvRect = collectionView.frame
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth, height: cvRect.size.height)
    }
}
