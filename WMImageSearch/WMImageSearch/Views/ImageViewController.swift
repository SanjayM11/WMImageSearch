//
//  ImageViewController.swift
//  WMImageSearch
//
//  Created by Sanjay Mohnani on 16/05/20.
//  Copyright © 2020 Sanjay Mohnani. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewLayoutDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var aView: UIView!
    @IBOutlet weak var dropDownViewHeightConstraint: NSLayoutConstraint!
    
    private var pageNumber = 1
    private var searchedText = ""
    private var totalNumberOfRecords = 0
    private let batchSizePerRequest = 20
    
    private var list = [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionView.collectionViewLayout as? CollectionViewLayout{
            layout.delegate = self
        }
        hideDropdownView()
        searchBar.endEditing(true)
        
        tableView.layer.cornerRadius = 5
        let blackColor = UIColor.black
        tableView.layer.borderColor = blackColor.cgColor
        tableView.layer.borderWidth = 1
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delaysTouchesBegan = true
        longPressGestureRecognizer.delegate = self
        aView.addGestureRecognizer(longPressGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        aView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier.kIVCReuseIdentifier,
                                                      for: indexPath) as! CollectionViewCell
        let object = list[indexPath.row]
        cell.imageView.imageFromServerURL(urlString: object.previewURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideDropdownView()
        let storyboard = UIStoryboard(name: Constants.kMainStoryboardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.kDetailViewControllerId) as? DetailImageViewController{
            vc.initializeWithList(self.list, index: indexPath.row)
            self.present(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideDropdownView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 60.0 {
            if batchSizePerRequest * pageNumber >= totalNumberOfRecords{
                return
            }
            self.executeRequest()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // search bar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        hideDropdownView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText(searchBar.text!)
        hideDropdownView()
    }
    
    private func searchText(_ text : String){
        searchedText = text
        searchBar.resignFirstResponder()
        if text.isEmpty{
            self.showAlertWithTitle(MessageStrings.kNoInputString, message: MessageStrings.kNoInputMessage, buttonTitle: MessageStrings.kOK)
        }else{
            self.list = []
            pageNumber = 0
            executeRequest()
        }
    }
    
    func executeRequest(){
        pageNumber += 1
        RequestManager.executeRequestWithSearchedText(searchedText, pageNumber: pageNumber, completion: {error, data -> Void in
            if let error = error{
                self.showAlertWithTitle(error.title, message: error.message, buttonTitle: error.buttonTitle)
            }
            else{
                if let data = data{
                    self.list.append(contentsOf: data.hits)
                    self.totalNumberOfRecords = data.total
                    PersistentStore.savaSearchedText(self.searchedText)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        if self.list.count <= 0{
                            self.showAlertWithTitle(MessageStrings.kSorryString, message: MessageStrings.kNoRecordsMessage, buttonTitle: MessageStrings.kOK)
                        }
                    }
                }
            }
        })
    }
    
    //CollectionViewLayoutDelegate
    func sizeForViewAtIndexPath(_ indexPath:IndexPath) -> CGSize{
        let item = list[indexPath.row]
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let ratioX = screenWidth / CGFloat(Constants.kBaseWidth)
        return CGSize(width: CGFloat(item.previewWidth) * ratioX, height: CGFloat(item.previewHeight) * ratioX)
    }
    
    //Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = PersistentStore.getRecentSearchedText(){
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.kIVCTableCellReuseIdentifier, for: indexPath)
        if let list = PersistentStore.getRecentSearchedText(), list.count > indexPath.row{
            cell.textLabel?.text = list[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = PersistentStore.getRecentSearchedText(), list.count > indexPath.row{
            searchBar.text = list[indexPath.row]
            searchText(searchBar.text!)
            hideDropdownView()
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    //drop down
    func showDropDownView(){
        if let list = PersistentStore.getRecentSearchedText(), list.count > 0{
            tableView.reloadData()
            tableView.isScrollEnabled = false
            dropDownViewHeightConstraint.constant = CGFloat(32 * list.count)
            dropDownView.isHidden = false
        }else {
            dropDownView.isHidden = true
        }
    }
    
    func hideDropdownView(){
        dropDownView.isHidden = true
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer){
        searchBar.becomeFirstResponder()
    }
    
    @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.began{
            
        }
        else if gestureReconizer.state == UIGestureRecognizer.State.ended {
            showDropDownView()
        }
    }
    
    func showAlertWithTitle(_ title : String = MessageStrings.kErrorString, message : String, buttonTitle : String = MessageStrings.kOK){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
