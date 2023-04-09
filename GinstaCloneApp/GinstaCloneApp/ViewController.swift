//
//  ViewController.swift
//  GinstaCloneApp
//
//  Created by ümit yusuf erdem on 24.03.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        }
    
   
    @IBAction func signInClicked(_ sender: Any) {
        
        // emailText ve passwordText boş değil ise Auth sınıfından nesne oluştur ve kullanıcı girişi metodunu kullan (signIn)
        
        if emailText.text! != "" && passwordText.text! != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    
       // eğer bir hata varsa makeAlert metodunu kullan ve ekranda hata uyarısı ver.
                    self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Error")
                } else {
       // eğer hata yoksa toFeedVC segue'sini kullan.
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)

                }
            }
        } else {
            
        // Eğer emailText ve passwordText boş ise makeAlert metodunu kullan ve ekrana uyarı ver.
            
            makeAlert(titleInput: "Hata", messageInput: "Kullanıcı adı ve şifre giriniz.")
        }

    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        // emailText ve passwordText boş değil ise ("") Auth sınıfından obje oluştur ( Auth.auth() )ve kullanıcı oluştur (createUser)
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    
        // eğer bir hata varsa ekrana uyarı ver. ( makeAlert() )
                    self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Error")
                } else {
        // eğer hata yoksa toFeedVC seguesini çalıştır.
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
        // emailText ve passwordText boş ise ekrana uyarı ver.
            
            makeAlert(titleInput: "Hata", messageInput: "Kullanıcı adı ve şifre giriniz.")
        }
        
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
    

}


