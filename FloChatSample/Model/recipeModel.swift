//
//  recipeModel.swift
//  FloChatSample
//
//  Created by Seevan Ranka on 28/12/17.
//  Copyright © 2017 Seevan Ranka. All rights reserved.
//

import Foundation
class recipeModel {
   /* "collection_id" = 340;
    description = "The best and most affordable booze your city has to offer ";
    "image_url" = "https://b.zmtcdn.com/data/collections/5ae77acfc2f3d7a9c7cc2dbf4ba6aecd_1421659018_l.jpg";
    "res_count" = 9;
    "share_url" = "http://www.zoma.to/c-1/340";
    title = "Pocket friendly bars";
    url = "https://www.zomato.com/ahmedabad/cheap-bars?utm_source=OUWT&utm_medium=api&utm_campaign=v2.1";*/
    let collection_id: Int64?
    var title: String
    var share_url: String?
    var url: String
    var description: String?
    var image_url: String
    var res_count: Int
    
    init(collection_id: Int64, title: String, share_url: String, url: String, description: String, image_url: String, res_count: Int) {
        self.collection_id = collection_id
        self.title = title
        self.share_url = share_url
        self.url = url
        self.description = description
        self.image_url = image_url
        self.res_count = res_count
    }
}
