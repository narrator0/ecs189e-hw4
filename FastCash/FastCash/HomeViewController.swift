//
//  HomeViewController.swift
//  FastCash
//
//  Created by Trevor Carpenter on 1/18/21.
//  Copyright © 2021 Trevor Carpenter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    
    var phoneNumber = ""
    var name = ""
    var totalAmount = 0.0
    var accounts: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IN Load")
        if self.name == "" {
            self.name = self.phoneNumber
        }
        self.Name.text = self.name
        print(self.name)
        print(self.Name.text)
        self.TableView.dataSource = self
        self.totalAmount = accounts.reduce(0.0, {$0+$1.amount})
        self.TotalAmountLabel.text = String(format: "Your Total Amount is $%.02f", self.totalAmount)
    }
    
    @IBAction func nameEdited() {
        print("edited")
        print(self.phoneNumber)
        var text = Name.text ?? ""
        print(text)
        if text.count == 0{
            text = self.phoneNumber
        }
        print(text)
        self.name = text
        Name.text = text
        Api.setName(name: self.name, completion: { response, error in
            
        })
    }
    
    @IBAction func logOut(_ sender: Any) {
        print("logging Out")
        print(self.accounts)
        Api.setAccounts(accounts: self.accounts, completion: { response, error in
            
        })
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        
        guard let loginVC = vc as? ViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        if let nav = self.presentingViewController as? UINavigationController {
            nav.viewControllers = [loginVC]
            self.dismiss(animated: true, completion: nil)
        } else {
            assertionFailure("no navigation controller")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") else {
            assertionFailure("idk what happened")
            return UITableViewCell.init()
        }
        cell.textLabel?.text = accounts[indexPath.row].name
        let amount = String(format: "$%.02f", accounts[indexPath.row].amount)
        cell.detailTextLabel?.text = amount
        
        
        return cell
    }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
}
