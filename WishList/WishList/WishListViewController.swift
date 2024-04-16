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
        getProductList()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell", for: indexPath)
        
        let id = productList[indexPath.row].id
        let title = productList[indexPath.row].title
        let price = productList[indexPath.row].price
        
        cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            productList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            deleteProductList()
        }
    }
    
    
    private func getProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        let productList = try? context.fetch(request)
        self.productList = productList
        
    }
    
    func deleteProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        guard let productList = try? context.fetch(request) else { return }
        context.delete(productList)
        
        try? context.save()
    }
    

}


    

    
    

