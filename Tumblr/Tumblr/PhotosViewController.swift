//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by sabzo on 9/3/17.
//  Copyright © 2017 SintuLabs. All rights reserved.

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var postTable: UITableView!

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTable.delegate = self
        postTable.dataSource = self
        
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    self.posts = Post.getPostsFromJsonObject(data: data)
                    self.postTable.reloadData()
                }
        });
        task.resume()
    
        postTable.rowHeight = 240
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count > 0 {
            return posts.count
        }
        else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PostCell
        
        if indexPath.row < posts.count {
            let post = posts[indexPath.row]
            cell.ivMain.setImageWith(post.url)
        }
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = postTable.indexPath(for: cell)
        let post = posts[indexPath!.row]
        
        let vc: PhotoDetailController = segue.destination as! PhotoDetailController
        vc.post = post
    }
    
}
