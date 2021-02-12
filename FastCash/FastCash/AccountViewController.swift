//
//  AccountViewController.swift
//  FastCash
//
//  Created by arfullight on 2/12/21.
//  Copyright © 2021 Trevor Carpenter. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    var wallet = Wallet()
    var accountIndex: Int = -1
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in account controller")
        self.accountNameLabel.text = self.wallet.accounts[self.accountIndex].name
        if self.accountIndex >= self.wallet.accounts.count - 1 {
            self.accountAmountLabel.text = self.formatMoney(amount: self.wallet.accounts[self.accountIndex].amount)
        }

        // Do any additional setup after loading the view.
    }
    
    func formatMoney(amount: Double) -> String {
        let charactersRev: [Character] = String(format: "$%.02f", amount).reversed()
        if charactersRev.count < 7 {
            return String(format: "$%.02f", amount)
        }
        var newChars: [Character] = []
        for (index, char) in zip(0...(charactersRev.count-1), charactersRev) {
            if (index-6)%3 == 0 && (index-6) > -1 && char != "$"{
                newChars.append(",")
                newChars.append(char)
            } else {
                newChars.append(char)
            }
        }
        
        return String(newChars.reversed())
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func depositButtonPressed(_ sender: Any) {
    }
    
    @IBAction func withdrawButtonPressed(_ sender: Any) {
    }
    
    @IBAction func transferButtonPressed(_ sender: Any) {
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        Api.removeAccount(wallet: self.wallet, removeAccountat: self.accountIndex) { res, err in
            let homeVC = self.navigationController?.viewControllers.first as? HomeViewController
            homeVC?.updateWallet(response: res)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}