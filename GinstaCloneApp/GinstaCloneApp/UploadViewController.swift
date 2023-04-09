//
//  UploadViewController.swift
//  GinstaCloneApp
//
//  Created by ümit yusuf erdem on 24.03.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.isUserInteractionEnabled = true // imageView'i tıklanabilir yap.
        
        // gestureRegocnizer tanımla
        let gestureRegocnizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        
        // imageView içerisine gestureRegocnizer'i ekle.
        imageView.addGestureRecognizer(gestureRegocnizer)
        
    }
    
    @objc func choseImage(){
        
        
        // kullanıcının kütüphanesine erişebilmek için pickerController ekle.
        let pickerController = UIImagePickerController()
        
        // pickerController delegasyonlarını tanımla.
        pickerController.delegate = self
        
        // kaynak tipi olarak fotoğraf kütüphanesini belirle.
        pickerController.sourceType = .photoLibrary
        
        // pickerController'i present et.
        present(pickerController, animated: true,completion: nil)
        
    }
    
    
    
        // kullanıcı görseli seçtikten sonra ne olsun.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    
    
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        
        // Önce Storage sınıfından storage instance'si oluştur. ( Storage.storage() )
        let storage = Storage.storage()
        
        // Ardından storage referansı oluştur. ( Storage.reference() )
        let storageReferance = storage.reference()
        
        // Kaydedilmek istenen belgeyi seç ( .child("media") )
        let mediaFolder = storageReferance.child("media")
        
        
        // imageView içerisindeki storage'a yüklenmek istenen görseli al ve dataya çevir ( .jpegData() )
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            // bir UUID oluştur ve (.uuidString) ile bunu string'i dönüştür.
            let uuid = UUID().uuidString
            
            // Bir imageReferance belirle ve adını uuid ile gelen verinin sonuna jpg uzantısı ekleyerek belirle
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            // İmage referance içerisine jpegData olarak çevrilmiş olan görseli yükle.
            imageReferance.putData(data, metadata: nil) { [self] (metadata,error) in
                
           // Eğer bir hata oluşursa
                if error != nil {
                    
            // Ekrana bir alert gönder.
                    makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
                } else {
          
            // Eğer hata oluşmaz ise kullanıcı aldığı veriyi (jpgData) hangi urlye kaydetmiş diye bak.
                    imageReferance.downloadURL { (url, error) in
                        
            // Eğer hata boş ise
                        if error == nil {
                            
            // İmage URL sini absoluteString olarak belirle.
                            let imageUrl = url?.absoluteString
                            
                            
                            // DATABASE
                            
                            
                    // FireStore database'yi Firestore sınıfından oluştur.
                            let firestoreDatabese = Firestore.firestore()
                            
                    // FireStore referansını oluştur.
                            var firestoreReference : DocumentReference? = nil
                            // FieldValue.serverTimestamp() o anki tarihi ve saati verir.
                            let firestorePost = ["imageUrl" : imageUrl!,"postedBy" : Auth.auth().currentUser!.email!, "postComment": self.commentText.text!,"Date": FieldValue.serverTimestamp(), "likes": 0] as [String:Any]
                            
                    // Hangi kolleksiyona ekleyelim. ( .collection) ve doküman ekle (.addDocument)
                    // doküman içindeki veriler ne şekilde çekilecek (data: firestorePost [String:Any])
                            
                            firestoreReference = firestoreDatabese.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                
                    // Hata mesajı boş değilse. 
                                
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    
                   // Hata yoksa imageView görselini default değere götür.
                                    self.imageView.image = UIImage(named: "kenny.jpeg")
                                    
                   // Hata yoksa commentText değerini default ("") yap.
                                    self.commentText.text = ""
                                    
                   // Hata yoksa tabBar içindeki kaçıncı indexe götüreyim?
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                                
                            })
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    

 
}
