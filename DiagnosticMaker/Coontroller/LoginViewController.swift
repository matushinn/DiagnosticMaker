//
//  LoginViewController.swift
//  DiagnosticMaker
//
//  Created by 大江祥太郎 on 2021/07/23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationContrllerを消す
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //viewをタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func register(_ sender: Any) {
        //emailtextfield,passwordtextfieldが空でない、
        if emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true {
            
            //アカウントを作成する　クロージャーは一旦後ろがよばれて結果がresultに入る
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result,error ) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                //画面遷移
                let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
                viewVC.userName = "テスト"
                
                self.navigationController?.pushViewController(viewVC, animated: true)
                
                
            }
            
        }
        
    }
    

    

}
