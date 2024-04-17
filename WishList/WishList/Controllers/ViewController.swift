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
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var saveWishListButton: UIButton!
    @IBOutlet weak var showAnotherButton: UIButton!
    @IBOutlet weak var showWishListButton: UIButton!
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
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
    
    let refreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchRemoteProduct()
        initRefresh()
    }
    
    func configureUI() {
        titleLabel.font = .boldSystemFont(ofSize: 23)
        
        saveWishListButton.layer.cornerRadius = 10
        saveWishListButton.setTitleColor(.white, for: .normal)
        saveWishListButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        saveWishListButton.backgroundColor = .green
        
        showAnotherButton.layer.cornerRadius = 10
        showAnotherButton.setTitleColor(.white, for: .normal)
        showAnotherButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        showAnotherButton.backgroundColor = .red
        
        showWishListButton.layer.cornerRadius = 10
        showWishListButton.setTitleColor(.white, for: .normal)
        showWishListButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        showWishListButton.backgroundColor = .lightGray
        
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
            //print(#function)
        }
    }
    
    
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext, let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
        //print(#function)
    }
    
    
    private func fetchRemoteProduct() {
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
            task.resume()
        }
    }
    
    
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshProduct(refresh:)), for: .valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        scrollView.addSubview(refreshControl)
    }
    
    
    @objc func refreshProduct(refresh: UIRefreshControl) {
        print("refreshProduct")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchRemoteProduct()
            self.scrollView.reloadInputViews()
            refresh.endRefreshing()
        }
    }
    
}



