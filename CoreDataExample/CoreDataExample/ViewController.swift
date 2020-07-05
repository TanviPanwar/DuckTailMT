

import UIKit
class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource ,CustomCellDelegate{
 
    
    
    //MARK:- Outlets
    @IBOutlet weak var productTF: UITextField!
    @IBOutlet weak var productTableView: UITableView!
    
    var totalProducts = 0
    var products = [Product]()
    
    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.delegate = self
        productTableView.dataSource = self
        fetchProduct()
    }
    
    
    //MARK:- Actions
    @IBAction func addNewProductAction(_ sender: Any) {
        var found = false
            for product in self.products {
                       let productname = product.name
                       if(productname == productTF.text!){
                        alert(title: "Alert", message: "Product with this name allready exists")
                        found = true
                        break
                       }
                   }
        if(!found &&  productTF.text! != ""){
            createProduct(name: productTF.text!, qty: 2)

        }
       
    }
    
    
    @objc func increaseProductQuantity(indexPAth: IndexPath){
         if(Int(self.products[indexPAth.row].quantity) < 50){
            self.updateProduct(name: self.products[indexPAth.row].name!, qty: Int(self.products[indexPAth.row].quantity) + 1,index: indexPAth.row)
        }
    }
    
    @objc func decreaseProductQuantity(indexPAth: IndexPath){
        if(Int(self.products[indexPAth.row].quantity) > 1){
            self.updateProduct(name: self.products[indexPAth.row].name!, qty: Int(self.products[indexPAth.row].quantity) - 1,index: indexPAth.row)
        }
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    
    //MARK:- Custom Cell Delegates
    func incButtonTapped(cell: ProductTVC, didTappedThe button: UIButton?) {
         guard let indexPath = productTableView.indexPath(for: cell) else  { return }
        self.increaseProductQuantity(indexPAth: indexPath)
                
     }
     
     func decButtonTapped(cell: ProductTVC, didTappedThe button: UIButton?) {
         guard let indexPath = productTableView.indexPath(for: cell) else  { return }
        self.decreaseProductQuantity(indexPAth: indexPath)
               
     }
     
    //MARK:- Tavle View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ProductTVC", for: indexPath) as! ProductTVC
        cell.cellDelegate = self
        cell.productLabel.text = products[indexPath.row].name
        cell.productQtyLabel.text = "\(products[indexPath.row].quantity)"
       

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                           let product = products[indexPath.row]
                            PersistentStorage.shared.context.delete(product)
                           products.remove(at: indexPath.row)
                           tableView.deleteRows(at: [indexPath], with: .fade)
            
                          PersistentStorage.shared.saveContext()
                          tableView.reloadData()
        }
    }
    
    
    
    //MARK:- CoreData Methods
    func createProduct(name: String, qty: Int)
    {
        let product = Product(context: PersistentStorage.shared.context)
       
            product.name = name
            product.quantity = 1
            PersistentStorage.shared.saveContext()
            fetchProduct()
        
        
        
    }
    
    
    

    func updateProduct(name: String, qty: Int, index : Int)
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Product.fetchRequest()) as? [Product] else {return}
            
            for coredataIndex in result.indices{
                if result[coredataIndex].name == name{
                    result[coredataIndex].setValue(qty, forKey: "quantity")
                    self.products[index].quantity = Int16(qty)
                    PersistentStorage.shared.saveContext()
                }
            }
            productTableView.reloadData()
            
           
            
        } catch let error
        {
            debugPrint(error)
        }
        
    }
    
    
    func fetchProduct()
    {
        
        
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Product.fetchRequest()) as? [Product] else {return}
            
            self.totalProducts = result.count
            self.products = result
            productTableView.reloadData()
            
        } catch let error
        {
            debugPrint(error)
        }
        
    }
    
    
}

