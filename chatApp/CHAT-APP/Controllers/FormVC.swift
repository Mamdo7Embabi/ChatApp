//
//  FormVC.swift
//  CHAT-APP
//
//  Created by MAC on 1/11/2012 ERA1.
//  Copyright © 2012 ERA1 mamdouh. All rights reserved.
//

import UIKit
import Firebase
class FormVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    

}

extension FormVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! FormCell
        
        if indexPath.row == 0{
            cell.userNameContainer.isHidden = true
            cell.actionBtn.setTitle("Login", for: .normal)
            cell.slidBtn.setTitle("Sing Up", for: .normal)
            cell.slidBtn.addTarget(self, action: #selector(slidToSignIn), for: .touchUpInside)

            cell.actionBtn.addTarget(self, action: #selector(didPressedSignIn), for: .touchUpInside)
        }
        else if indexPath.row == 1 {
            
            cell.userNameContainer.isHidden = false
            cell.actionBtn.setTitle("Sing Up", for: .normal)
            cell.slidBtn.setTitle("Sing In ", for: .normal)
            cell.slidBtn.addTarget(self, action: #selector(slidToSignUp), for: .touchUpInside)
            
            cell.actionBtn.addTarget(self, action: #selector(didPressedSignUp), for: .touchUpInside)

        }
        
        return cell
    }
    
    @objc func slidToSignIn(_ sender:UIButton){
        let indexPath =  IndexPath(row: 1, section: 0)
        
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
    }
    
   @objc func didPressedSignUp(){
    
    let indexPath = IndexPath(row: 1, section: 0)
    
    let cell  = self.collectionView.cellForItem(at: indexPath) as! FormCell
    
    guard let email = cell.emaiTextField.text, let password = cell.passwordTextField.text else{ return }
        if (email.isEmpty == true || password.isEmpty == true){
        self.displyError(error: "Empty Fields")
        
        }else{
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if (error  == nil){
            
            guard let userId = result?.user.uid , let userName = cell.userNameTextField.text else {return}
        
            let refrence = Database.database().reference()
            let user =  refrence.child("users").child(userId)
       
            let dataArray:[String:Any]  =  ["username": userName]
            user.setValue(dataArray)
            
            self.dismiss(animated: true, completion: nil)
            cell.emaiTextField.text  = ""
            cell.passwordTextField.text = ""
            cell.userNameTextField.text =  ""
        }
        
    }
}
    }
       @objc func didPressedSignIn(){
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            let cell  = self.collectionView.cellForItem(at: indexPath) as! FormCell
            
            guard let email = cell.emaiTextField.text, let password = cell.passwordTextField.text else{ return }
            if (email.isEmpty == true || password.isEmpty == true){
                self.displyError(error: "Empty Fields")
            }else{

            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                    cell.emaiTextField.text = ""
                    cell.passwordTextField.text = ""
                }else{
                    self.displyError(error: "Wrong Email or Password")
                    cell.emaiTextField.text = ""
                    cell.passwordTextField.text = ""
                }
            })
        }
        }
    
    func displyError(error:String){
        let alert = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    
    @objc func slidToSignUp(){
        let indexPath =  IndexPath(row: 0, section: 0)
        
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
}
