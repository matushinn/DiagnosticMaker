//
//  ViewController.swift
//  DiagnosticMaker
//
//  Created by 大江祥太郎 on 2021/07/21.
//

import UIKit
import BubbleTransition
import Firebase
import FirebaseFirestore

class FeedItem {
    
    var meigen:String!
    var auther:String!
    
}

class ViewController: UIViewController,XMLParserDelegate,UIViewControllerTransitioningDelegate{
    
    var userName = String()
    var url = "https://prog-8.com/images/html/advanced/top.png"
    
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    @IBOutlet weak var toFeedButton: UIButton!
    
    let db = Firestore.firestore()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    var parser = XMLParser()
    
    var feedItem = [FeedItem]()
    
    //nilを許容するから
    var currentElementName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //丸にできる
        toFeedButton.layer.cornerRadius = toFeedButton.frame.width/2
        //navigationContrllerを消す
        self.navigationController?.isNavigationBarHidden = true
        
        
        //XML解析を行う
        let url = "http://meigen.doodlenote.net/api?c=1"
        let urlToSend = URL(string: url)
        
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        parser.parse()
        
    }
    //①responseが当たった時に呼ばれる
    /*
     elementName(要素)→”Data”が見つかった！ -> feedItem(配列)の中身 [ [FeedItem()] ]
     -> [ [meigen:””,auther:”] ]
     -> Dictionary型→キーバリュー型
     
     -> [ [meigen:” ”,auther:” ”] , [meigen:” ”,auther:” ”] ]
     */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        //①elementName = response
        if elementName == "data" {
            //②feedItemの初期化
            self.feedItem.append(FeedItem())
        }else{
            //①currentElementName=responseが入る
            //③currentElementName = meigen
            //④currentElementName = auther
            currentElementName = elementName
        }
    }
    
    //responseが見つかった後
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.feedItem.count > 0 {
            //meigenとautherを処理していく
            let lastItem = self.feedItem[self.feedItem.count - 1]
            
            switch self.currentElementName {
            case "meigen":
                //キー値が入る
                //③
                lastItem.meigen = string
            case "auther":
                //④
                lastItem.auther = string
                
                meigenLabel.text = lastItem.meigen + "\n" + lastItem.auther
            default:
                //②dataなので
                break
            }
            
        }
        //①はfeedItemがないのでここが呼ばれる
    }
    //</data>になった時に呼ばれる
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    @IBAction func share(_ sender: Any) {
        
        //アクティビティーVCを出す
        var postString = String()
        postString = "\(userName)さんを表す名言:\n\(meigenLabel.text!)\n#あなたを表す名言メーカー"
        
        let shareItems = [postString] as [String]
        
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func sendData(_ sender: Any) {
        //FireStoreへ値を保存する
        
        if let quote = meigenLabel.text,let userName = Auth.auth().currentUser?.uid {
            db.collection("feed").addDocument(data:
                                                ["userName":userName,"quote":meigenLabel.text!,"photoURL":url,"createdAt":Date().timeIntervalSince1970]) { error in
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func toFeedVC(_ sender: Any) {
        performSegue(withIdentifier: "feedVC", sender: nil)
    }
    
    
    
    
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FeedViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.modalPresentationCapturesStatusBarAppearance = true
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = toFeedButton.center
        transition.bubbleColor = toFeedButton.backgroundColor!
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = toFeedButton.center
        transition.bubbleColor = toFeedButton.backgroundColor!
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
}

