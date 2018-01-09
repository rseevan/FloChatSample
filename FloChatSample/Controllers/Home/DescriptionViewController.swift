//
//  DescriptionViewController.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import UIKit
import HTMLString


class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var responseCount: UILabel!
    
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    var recipeItem : recipeModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(BackAction(sender:)))
        let title = recipeItem.title.removingHTMLEntities
        navigationItem.title = title
        recipeImage.sd_setImage(with: URL(string: recipeItem.image_url), placeholderImage: UIImage(named: "DemoImage1.jpg"))
        recipeDescription.text = recipeItem.description
        responseCount.text = recipeItem.res_count.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func BackAction(sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnZomatoClicked(_ sender: Any) {
        let urlString = recipeItem.url
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
