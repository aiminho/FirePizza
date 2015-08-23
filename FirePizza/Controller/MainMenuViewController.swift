//
//  MainMenuViewController.swift
//  FirePizza
//
//  Created by Anak Mirasing on 3/17/2558 BE.
//  Copyright (c) 2558 iGROOMGRiM. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    var products = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        println("MainMenuViewController")
        // Do any additional setup after loading the view.
        
        self.title = "FirePizza Menu"
        
        getAllProducts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - Get All Products
    func getAllProducts(){
        
        self.menuTableView.alpha = 0;
        
        var ref = RootRef.childByAppendingPath("products")
        
        // you can use observeSingleEventOfType for reading data once
        ref.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let json = JSON(snapshot.value)
            println("\(json.count)")
            if (json.count != 0) {
                println("Show Data on Path: \(snapshot.ref)")
                // clear all product before append when data on firebase have change
                self.clearProductsArray()
                
                for (key:String, subJson:JSON) in json {
                    self.products.append(subJson)
                }
    
                self.menuTableView.reloadData()
                
                UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.menuTableView.alpha = 1
                }, completion: { finished in
                    println("MenuTableView Show!")
                })
                
            }else{
                println("No Data on Path: \(snapshot.ref)")
            }

        }, withCancelBlock: { error in
        
        })
    }
    
    func clearProductsArray(){
        products.removeAll(keepCapacity: false)
    }
    
    //MARK : - TableView Datasource,Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func cellConfigure(cell: UITableViewCell, product:JSON){
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let priceLabel = cell.viewWithTag(3) as! UILabel
        
        nameLabel.text = product["name"].string
        priceLabel.text = "$"+product["price"].stringValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! UITableViewCell
        let product = products[indexPath.row]
        
        cellConfigure(cell, product: product)
        
        return cell
    }

}
