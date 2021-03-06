//
//  ProductViewController.swift
//  NETShop
//
//  Created by Dhruvin Shiyani on 28/08/19.
//  Copyright © 2019 Dhruvin Shiyani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Toast_Swift
import SideMenu

class ProductViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var tblProductsList: UITableView!
    
    var imageURL = "http://localhost/app/uploadPhoto/"
    
    
    //var arr_product_id = [String]()
    //var arr_product_name = [String]()
    //var arr_product_image = [String]()
    //var arr_product_detail = [String]()
    //var arr_product_price = [String]()
    //var arr_category_id = [String]()
    var sub_categorys_id = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.API_ListProduct()
        self.tblProductsList.dataSource = self
        self.tblProductsList.delegate = self
        self.tblProductsList.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JSONField.arr_product_id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductsList.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        //cell.lblProductID.text = arr_product_id[indexPath.row]
        
        cell.lblProductName.text = JSONField.arr_product_name[indexPath.row]
        
        
        if let url = URL(string: JSONField.arr_product_photo[indexPath.row]) {
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                if let data = data
                {
                    let imgProduct = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgProductPhoto?.image = imgProduct
                    }
                }
            }
        }
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ProductDVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        ProductDVC.product_id = sub_categorys_id
        
        ProductDVC.arr_product_name = JSONField.arr_product_name[indexPath.row]
        ProductDVC.arr_product_details = JSONField.arr_product_detail[indexPath.row]
        ProductDVC.arr_product_price = JSONField.arr_product_price[indexPath.row]
        
        //ProductDVC.arr_product_image = arr_product_image[indexPath.row]
        
        self.navigationController?.pushViewController(ProductDVC, animated: true)
        //self.present(dvc1,animated: true,completion: nil)
        //ProductVC.sub_category_id = arr_sub_category_id[indexPath.row]
        
    }
    
    
    
    
    func fetch_product_by_sub_category(){
        let url = URL(string:WEB_URL.PRODUCTS_URL + sub_categorys_id)
        do{
            let allmydata = try Data(contentsOf: url!)
            let adata = try JSONSerialization.jsonObject(with: allmydata, options:JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            if let arrayJson = adata["product"] as? NSArray
            {
                //when you again request for sub catefory the id will be clear for new request
                JSONField.arr_product_id.removeAll()
                JSONField.arr_product_name.removeAll()
                JSONField.arr_product_price.removeAll()
                JSONField.arr_product_photo.removeAll()
                
                for index in 0...(adata["product"]?.count)! - 1{
                    let object = arrayJson[index]as! [String:AnyObject]
                    
                    let p_IdJson = (object["product_id"]as! String)
                    JSONField.arr_product_id.append(p_IdJson)
                    
                    let p_titleJson = (object["product_name"]as! String)
                    JSONField.arr_product_name.append(p_titleJson)
                    
                    let p_priceJson = (object["product_price"]as! String)
                    JSONField.arr_product_price.append(p_priceJson)
                    
                    let p_imageJson = (object["product_image"]as! String)
                    JSONField.arr_product_photo.append(p_imageJson)
                }
            }
        }
        catch{print("error:\(error)")
        }
    }
    
    
    
    
    
    /*
    func API_ListProduct() {
        
        let url = "http://localhost/app/products-listing.php?sub_category_id=\(sub_categorys_id)"
        
        Alamofire.request(url, method: .post ).responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                print(response.result)
                
                let result = try? JSON(data: response.data!)
                
                print(result!["product"])
                
                let resultArray = result!["product"]
                
                self.arr_product_id.removeAll()
                self.arr_product_name.removeAll()
                self.arr_product_image.removeAll()
                self.sub_categorys_id.removeAll()
                self.arr_product_detail.removeAll()
                self.arr_product_price.removeAll()
                
                for productlist in resultArray.arrayValue {
                    
                    let product_id = productlist["product_id"].stringValue
                    self.arr_product_id.append(product_id)
                    
                    let product_name = productlist["product_name"].stringValue
                    self.arr_product_name.append(product_name)
                    
                    let product_image = productlist["product_photo"].stringValue
                    self.arr_product_image.append(product_image)
                    
                    let sub_category_id = productlist["sub_category_id"].stringValue
                    self.sub_categorys_id.append(sub_category_id)
                    //print(self.arr_product_name)
                    
                    let product_details = productlist["product_details"].stringValue
                    self.arr_product_detail.append(product_details)
                    
                    let product_price = productlist["product_price"].stringValue
                    self.arr_product_price.append(product_price)
                    
                    
                }
                print(self.arr_product_id)
                self.tblProductsList.reloadData()
                break
                
            case .failure:
                print(response.error!)
                break
            }
        }
        
        
    }
    */
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
