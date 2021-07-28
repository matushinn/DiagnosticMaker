//
//  FeedViewController.swift
//  DiagnosticMaker
//
//  Created by 大江祥太郎 on 2021/07/28.
//

import UIKit
import BubbleTransition
import Firebase
import SDWebImage
import ViewAnimator
import FirebaseFirestore

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var interactiveTransition = BubbleInteractiveTransition()
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var feeds:[Feeds] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを二つ作る
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        
        //なくて調べてもよい
        tableView.separatorStyle = .none
        
        loadData()
    }
    
    func loadData(){
        //投稿されたものを受信する
        db.collection("feed").order(by: "createdAt").addSnapshotListener { snapShot, error in
            
            self.feeds = []
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    
                    if let userName = data["userName"] as? String,let quote = data["quote"] as? String,let photoURL = data["photoURL"] as? String {
                        
                        let newFeeds = Feeds(userName: userName, quote: quote, profileURL: photoURL)
                        self.feeds.append(newFeeds)
                        self.feeds.reverse()
                        
                        //データの更新が全て終わった後に呼ばれる、非同期処理、同期処理を調べる
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView = nil
                            self.tableView.reloadData()
                        }
                        
                        
                        
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        interactiveTransition.finish()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        // cell.userNameLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言"
//        cell.quoteLabel.text = "\(feeds[indexPath.row])さんを表す名言"+"\n"+feeds[indexPath.row].quote
        cell.quoteLabel.text = "テストさんを表す名言"+"\n"+feeds[indexPath.row].quote
        cell.profileImageView.sd_setImage(with: URL(string: feeds[indexPath.row
        ].profileURL), completed: nil)
        
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //tableViewの間に開けたい空白の長さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        return UITableView.automaticDimension
    }
    //headerの背景色の色を指定する
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //完全に消す
        return .leastNormalMagnitude
    }


}
