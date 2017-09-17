//
//  Post.swift
//  Tumblr
//
//  Created by sabzo on 9/14/17.
//  Copyright © 2017 SintuLabs. All rights reserved.
//

import Foundation

class Post {
    var caption: String
    var url: URL
    // Default Constructor
    init(_ caption: String, _ url: URL) {
        self.caption = caption
        self.url = url
    }
    
    // New post from JSON
    class func getPostsFromJsonObject (data: Data) -> [Post]{
        var posts: [Post] = []
        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
            let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
            let jsonPosts = responseFieldDictionary["posts"] as! [NSDictionary]
            
            for post in jsonPosts {
                //get image caption
                let caption = post["caption"] as! String
                
                // get post image url from JSON object serealized to a NSDictionary
                var imgUrl :URL? = nil

                if let photos = post.value(forKey: "photos") as? [NSDictionary] {
                    let imgUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
                    if let str = URL(string: imgUrlString!) {
                        imgUrl = str
                    } else {
                        // post missing photo url so skip loop
                        continue
                    }
                }
                // Add post to posts array
                posts.append(Post(caption, imgUrl!))
            
            }
        }
       
        return posts
    }
}



