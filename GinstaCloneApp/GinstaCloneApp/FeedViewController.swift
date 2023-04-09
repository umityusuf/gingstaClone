//
//  FeedViewController.swift
//  GinstaCloneApp
//
//  Created by ümit yusuf erdem on 24.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        
        
        // Veri çekmek için Firestore sınıfından firestore nesnesini bağla.
        let fireStoreDatabase = Firestore.firestore()
        
        /*
         let settings = fireStoreDatabase.settings
         settings.areTimestampsInSnapshotEnabled = true
         fireStoreDatabase.settings = settings
         */
        
        
        // Hangi collectiondan işlem yapmak istiyorum?  Neye göre sıralanacak ( .order:(by: "Date", descending: true) yapılırsa sıralama tarihe göre azalarak gider )
        // veri çekmek için .addSnapshotListener kullan.
        fireStoreDatabase.collection("Posts").order(by: "Date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
             // FireStore içerisindeki dökumanları for loop içerisine al ve document olarak sırasıyla değer ver.
                    for document in snapshot!.documents {
                        
            // DocumentID sini documentID olarak tanımla.
                        let documentID = document.documentID
           // documentIdArray'i içerisine sırayla alınan dökumanları ekle.
                        self.documentIdArray.append(documentID)
           // eğer postedBy içerisindeki değer String olarak alınabiliyor ise:
                        if let postedBy = document.get("postedBy") as? String {
           // userEmailArray içerisine postedBy olarak tanımlanan değerleri ekle.
                            self.userEmailArray.append(postedBy)
                        }
           // postedComment içerisndeki değer String olarak alınabiliyor ise:
                        if let postComment = document.get("postComment") as? String {
           // userCommentArray içerisine gelen postComment değerlerini ekle.
                            self.userCommentArray.append(postComment)
                        }
                        
           // likes değeri içerisindeki değer Int olarak alınabiliyor ise:
                        if let likeArray = document.get("likes") as? Int {
           // likeArray içerisine gelen likeArray değerlerini ekle.
                            self.likeArray.append(likeArray)
                        }
           // imageUrl değeri içerisindeki değer String olarak alınabiliyor ise:
                        if let imageUrl = document.get("imageUrl") as? String {
           // userImageArray içerisine imageUrl değerlerini ekle.
                            self.userImageArray.append(imageUrl)
                        }
                        
           // tableView içerisindeki görsel,comment, like değerleri birden fazla yazılmaması için .reloadData yaparak sayfayı yenile.
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // .dequeueReusableCell ile TableViewCell'ine verilmiş olan ismi tanımlayarak ve FeedCell'e cast ederek bağla.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    


}
