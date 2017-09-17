//
//  PostCell.swift
//  Tumblr
//
//  Created by sabzo on 9/12/17.
//  Copyright © 2017 SintuLabs. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var ivMain: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
