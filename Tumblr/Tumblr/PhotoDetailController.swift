//
//  PhotoDetailController.swift
//  Tumblr
//
//  Created by sabzo on 9/17/17.
//  Copyright © 2017 SintuLabs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoDetailController: UIViewController {
    @IBOutlet weak var ivPhotoDetail: UIImageView!
    
    @IBOutlet weak var lblPhotoDetail: UILabel!
    var post: Post? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        ivPhotoDetail.setImageWith(post!.url)
        lblPhotoDetail.text = post!.caption

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
