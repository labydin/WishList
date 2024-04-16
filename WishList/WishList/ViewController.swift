//
//  ViewController.swift
//  WishList
//
//  Created by 박준영 on 4/15/24.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var saveWishListButton: UIButton!
    @IBOutlet weak var showAnotherButton: UIButton!
    @IBOutlet weak var showWishListButton: UIButton!
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // currentProduct가 set되면, imageView. titleLabel, descriptionLabel, priceLabel에 각각 적절한 값을 지정합니다.
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else { return }
            
            DispatchQueue.main.async {
                self.productImage.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                self.priceLabel.text = currentProduct.price.formatted(.currency(code: "USD"))
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.productImage.image = image }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        fetchRemoteProduct()
    }
    
    func setUI() {
        titleLabel.font = .boldSystemFont(ofSize: 23)
        
        saveWishListButton.layer.cornerRadius = 10
        saveWishListButton.backgroundColor = .green
        saveWishListButton.setTitleColor(.white, for: .normal)
        
        showAnotherButton.layer.cornerRadius = 10
        showAnotherButton.backgroundColor = .red
        showAnotherButton.setTitleColor(.white, for: .normal)
        
        showWishListButton.layer.cornerRadius = 10
        showWishListButton.backgroundColor = .lightGray
        showWishListButton.setTitleColor(.white, for: .normal)
    }
    
    
    @IBAction func saveWishListButtonTapped(_ sender: UIButton) {
        saveWishProduct()
    }
    
    
    @IBAction func showAnotherButtonTapped(_ sender: UIButton) {
        fetchRemoteProduct()
    }
    
    
    @IBAction func showWishListButtonTapped(_ sender: UIButton) {
        if let wishlistVC = self.storyboard?.instantiateViewController(withIdentifier: "wishlistVC") as? WishListViewController {
            self.present(wishlistVC, animated: true, completion: nil)
            print(#function)
        } else {
            print(#function)
        }
    }
    
    
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext, let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
        print(#function)
    }
    
    
    private func fetchRemoteProduct() {
            // 1 ~ 100 사이의 랜덤한 Int 숫자를 가져옵니다.
            let productID = Int.random(in: 1 ... 100)
            
            // URLSession을 통해 RemoteProduct를 가져옵니다.
            if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else if let data = data {
                        do {
                            // product를 디코드하여, currentProduct 변수에 담습니다.
                            self.currentProduct = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        } catch {
                            print("Decode Error: \(error)")
                        }
                    }
                }
                
                // 네트워크 요청 시작
                task.resume()
            }
        }

}

