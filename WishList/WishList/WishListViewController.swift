//
//  WishListViewController.swift
//  WishList
//
//  Created by 박준영 on 4/15/24.
//

import UIKit
import CoreData



struct Product {
    let id: Int
    let title: String
    let price: Double
}



class WishListViewController: UITableViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var persistentContainer: NSPersistentContainer? {
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
    private var productList: [Product] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.dataSource = self
        setProductList()
    }
    
    
    private func setProductList() {
            guard let context = self.persistentContainer?.viewContext else { return }
        
            let request = Product.fetchRequest()
        
            if let productList = try? context.fetch(request) {
                self.productList = productList
            }
        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell", for: indexPath)
            
            let product = self.productList[indexPath.row]
            let id = product.id
            let title = product.title
            let price = product.price
            
            cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
            
            return cell
    }

    
    
}


    

    
    

