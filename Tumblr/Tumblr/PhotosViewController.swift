//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by sabzo on 9/3/17.
//  Copyright © 2017 SintuLabs. All rights reserved.

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var postTable: UITableView!

    var posts: [Post] = []
    var isMoreDataLoading = false
    var page = 0
    let totalPostsPerPage = 20
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTable.delegate = self
        postTable.dataSource = self
        
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        loadData(url: url!, initial: true)
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        postTable.insertSubview(refreshControl, at: 0)

        postTable.rowHeight = 240
        
    }

    // Action to take when user pulls screen to refresh
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        loadData(url: url!, initial: true)
        // reset page number
        page = 0
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
    

   

    // Preparation before the Segue to Details Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = postTable.indexPath(for: cell)
        let post = posts[indexPath!.row]
        
        let vc: PhotoDetailController = segue.destination as! PhotoDetailController
        vc.post = post
    }
    
    // Fetch data from API
    func loadData(url: URL,  initial:Bool) {
        let request = URLRequest(url: url)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if initial {
                        self.posts = Post.getPostsFromJsonObject(data: data)
                    } else {
                        for post in Post.getPostsFromJsonObject(data: data) {
                            self.posts.append(post)
                        }
                        //self.posts + Post.getPostsFromJsonObject(data: data)
                    }
            
                }
                self.isMoreDataLoading = false
                self.postTable.reloadData()
                self.refreshControl.endRefreshing()
        });
        task.resume()
        
    }
    
    // Update table contents based on how far user has scrolled down content
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = postTable.contentSize.height
            // Threshhold: The point the user has scrolled past half of the content in the TableView
            let scrollOffsetThreshold = scrollViewContentHeight / 2
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && postTable.isDragging) {
                isMoreDataLoading = true
                page += 1
                let offset = page * totalPostsPerPage
                let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset)")
                loadData(url: url!, initial: false)
            }
        }
    }
    
}
