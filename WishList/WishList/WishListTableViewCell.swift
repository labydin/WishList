//
//  WishListTableViewCell.swift
//  WishList
//
//  Created by 박준영 on 4/15/24.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var wishListLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
