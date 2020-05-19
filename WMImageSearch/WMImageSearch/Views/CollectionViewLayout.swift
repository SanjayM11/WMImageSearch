//
//  CollectionViewLayout.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 17/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutDelegate: class {
    func sizeForViewAtIndexPath(_ indexPath:IndexPath) -> CGSize
}

class CollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CollectionViewLayoutDelegate!
    private var _layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var _contentSize: CGSize!
    
    private(set) var totalItemsInSection = 0
    
    var ratioX : CGFloat{
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth / CGFloat(Constants.kBaseWidth)
    }
    
    //MARK: getters
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize: CGSize {
        let totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        if totalItemsInSection <= 0{
            return CGSize.zero
        }
        return _contentSize
    }
    
    //MARK: Override methods
    override func prepare() {
        _layoutMap.removeAll()
        totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        
        if totalItemsInSection > 0, let collectionView = collectionView{
            let xSpace:CGFloat = 5 * ratioX
            let ySpace:CGFloat = 5 * ratioX
            let availableWidth = collectionView.frame.size.width
            var currentX = xSpace
            var currentY = ySpace
            var currentRowHeight:CGFloat = 0
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            while itemIndex < totalItemsInSection {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let itemSize = self.delegate.sizeForViewAtIndexPath(indexPath)
                if currentRowHeight <= 0{
                    currentRowHeight = itemSize.height
                }
                let yRatio = CGFloat(currentRowHeight)/itemSize.height
                var xSize = itemSize.width * yRatio
                var ySize = itemSize.height * yRatio
                
                var frame = CGRect.zero
                if xSize < availableWidth - currentX{
                    frame = CGRect.init(x: currentX, y: currentY, width: xSize, height: ySize)
                    currentX = currentX + xSize + xSpace
                }
                else if itemSize.width < availableWidth - currentX{
                    let availableW = availableWidth - currentX - xSpace
                    let xRatio = availableW/itemSize.width
                    xSize = availableW
                    ySize = min(itemSize.height * xRatio, ySize)
                    frame = CGRect.init(x: currentX, y: currentY, width: xSize, height: ySize)
                    currentX = currentX + xSize + xSpace
                }
                else{
                    currentX = xSpace
                    currentY = currentY + ySpace + currentRowHeight
                    currentRowHeight = itemSize.height
                    frame = CGRect.init(x: currentX, y: currentY, width: itemSize.width, height: itemSize.height)
                    currentX = currentX + itemSize.width + xSpace
                }
                
                let attributeRect = frame
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect
                
                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                _layoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }
            _contentSize = CGSize(width: collectionView.bounds.width - contentInsets.left - contentInsets.right,
                                  height: contentSizeHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        for (_, layoutAttributes) in _layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return _layoutMap[indexPath]
    }
}
