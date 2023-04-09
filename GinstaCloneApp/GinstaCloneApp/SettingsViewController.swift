//
//  SettingsViewController.swift
//  GinstaCloneApp
//
//  Created by ümit yusuf erdem on 24.03.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        
        
        do {
       // signOut ile kullanıcı çıkışını Firebase'den yap.
            try Auth.auth().signOut()
            
       // çıkış yaptıktan sonra toViewController segue'sini çalıştır.
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            
      // Çıkış yapılamaz ise konsola error yazdır.
            print(error.localizedDescription)
        }
        
        
        
    }
  

}
