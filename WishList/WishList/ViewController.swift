//
//  ViewController.swift
//  WishList
//
//  Created by 박준영 on 4/15/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var saveWishListButton: UIButton!
    @IBOutlet weak var showAnotherButton: UIButton!
    @IBOutlet weak var showWishListButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    func setUI() {
        saveWishListButton.layer.cornerRadius = 10
        saveWishListButton.backgroundColor = .green
        saveWishListButton.setTitleColor(.white, for: .normal)
        
        showAnotherButton.layer.cornerRadius = 10
        showAnotherButton.backgroundColor = .red
        showAnotherButton.setTitleColor(.white, for: .normal)
        
        showWishListButton.layer.cornerRadius = 10
        showWishListButton.backgroundColor = .gray
        showWishListButton.setTitleColor(.white, for: .normal)
    }
    
    
    @IBAction func saveWishListButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func showAnotherButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func showWishListButtonTapped(_ sender: UIButton) {
        
        
    }
    
}

