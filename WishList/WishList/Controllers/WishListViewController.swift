//
//  WishListViewController.swift
//  WishList
//
//  Created by 박준영 on 4/15/24.
//

import UIKit
import CoreData



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
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WishListTableViewCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell", for: indexPath)
        
        //print(#function)
        
        let id = productList[indexPath.row].id
        let title = productList[indexPath.row].title
        let price = productList[indexPath.row].price.formatted(.currency(code: "USD"))
        
        cell.textLabel?.text = "[\(id)] \(title ?? "") - \(price)"
        
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
            deleteProductList(indexPath: indexPath.row)
            //print("삭제")
        }
    }
    
    
    private func getProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        guard let productList = try? context.fetch(request) else { return }
        
        self.productList = productList
        // print(#function)
    }
    
    private func deleteProductList(indexPath: Int) {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        guard let productList = try? context.fetch(request) else { return }
               
        context.delete(productList[indexPath])
        
        try? context.save()
    }
    

}


    

    
    

