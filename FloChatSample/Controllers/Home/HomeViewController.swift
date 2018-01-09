//
//  HomeViewController.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import HTMLString
import Toast_Swift
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var recipesArray = [recipeModel]()
    var LocalStorage = UserDefaults.standard

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipes"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(logout(sender:)))
        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swiped(gesture:)))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(downSwipeGesture)
        self.recipeCollectionView.scrollsToTop = true
    }

    override func viewWillAppear(_ animated: Bool) {
        ToastManager.shared.style = ToastStyle()
        self.view.makeToastActivity(.center)
        getCollection()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateItemSize()
    }
    
    func getCollection() {
        let url = "http://35.154.75.20:9090/test/ios"
        let url1 = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print("url1 : \(String(describing: url1))")
        
        Alamofire.request(
            URL(string: url1!)!,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization" : "Bearer FlochatIosTestApi"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    self.view.hideToastActivity()
                    let alert = UIAlertController(title: "Try Again and Swipe down", message: response.result.error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.cancel,handler: {_ in
                    });
                    alert.addAction(action)
                    self.present(alert, animated: true, completion:nil)
                    return
                }
                let data = response.result.value as! NSDictionary
                let recipeData = data.object(forKey: "collections") as! [NSDictionary]
                DBManager.instance.parseRecipes(data: recipeData)
                self.recipesArray = DBManager.instance.getRecipes()
                self.view.hideToastActivity()
                self.recipeCollectionView.reloadData()
        }
    }
    
    @objc func logout(sender: UIBarButtonItem){
        self.LocalStorage.set("", forKey: "USER_EMAIL")
        self.LocalStorage.set(false, forKey: "login")
        let vc = UIStoryboard(name: "Main", bundle: Bundle .main).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func swiped(gesture: UIGestureRecognizer) {
        ToastManager.shared.style = ToastStyle()
        self.view.makeToastActivity(.center)
        getCollection()
    }
    func updateItemSize() {
        if recipesArray.count > 0 {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let totalSpace = layout.sectionInset.left
                + layout.sectionInset.right
                + (layout.minimumInteritemSpacing * CGFloat(2 - 1))
            let size = Int(((recipeCollectionView?.bounds.width)! - totalSpace) / CGFloat(2))
            layout.itemSize = CGSize(width: size, height: size)
            layout.minimumInteritemSpacing = 7.0
            layout.minimumLineSpacing = 7.0
            recipeCollectionView!.collectionViewLayout = layout
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let recipeItem = recipesArray[indexPath.item]
        let title = recipeItem.title.removingHTMLEntities
        cell.title.text = title
        cell.recipeImage.sd_setImage(with: URL(string: recipeItem.image_url), placeholderImage: UIImage(named: "DemoImage1.jpg"))
        cell.layer.cornerRadius = 3
        cell.recipeImage.layer.cornerRadius = 3
        cell.recipeImage.clipsToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle .main).instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
            vc.recipeItem = self.recipesArray[indexPath.row]
         let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}
