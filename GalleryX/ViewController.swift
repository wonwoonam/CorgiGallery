//
//  ViewController.swift
//  GalleryX
//
//  Created by Won Woo Nam on 9/17/21.
//

import UIKit
import Alamofire
import FirebaseStorage


class ViewController: UIViewController {

    
    var tempImg = UIImage()
    @IBOutlet weak var UploadedImage: UIImageView!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var MintingButton: UIButton!
    var walletAddress = ""
    var tempImgUrl = ""
    var alert2Message = ""
    var tokenId = ""
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let alert = UIAlertController(title: "Upload Image", message: "You haven't uploaded any images.", preferredStyle: .alert)
    
    var alert2 = UIAlertController(title: "GXT Minted", message: "You haven't uploaded any images.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (walletAddress == ""){
            getAccount {
                print(self.walletAddress)
            }
        }
        
        UploadButton.layer.cornerRadius = 10
        MintingButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.tintColor = UIColor(red: 183/255, green: 156/255, blue: 109/255, alpha: 1.0)
        tempImg = UploadedImage.image ?? UIImage()
        
        

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        
        
       

        // Do any additional setup after loading the view.
    }
    @IBAction func didTapButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
    }
  
    
    @IBAction func MintingPressed(_ sender: Any) {
        
        
        if UploadedImage.image == tempImg{
            self.present(alert, animated: true)
        }else{
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            getURL(img: UploadedImage.image ?? UIImage())
            
        }
    }
    
    func getAccount(completionHandler:  @escaping () -> ()){
        let url = "https://wallet-api.klaytnapi.com/v2/account"
        let headers : HTTPHeaders = ["Content-Type": "application/json", "X-Chain-Id": "1001"]
        AF.request(url, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                   
                    let responseDict = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] as NSDictionary?
                    print(responseDict)
                    self.walletAddress = responseDict?["address"] as? String ?? ""

                    
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
                completionHandler()
        }
    }
    
    func mintToken(completionHandler:  @escaping () -> ()){
    
        count = count+1
  
        let id = "0x" + String(count)
        tokenId = id
        
        let param = ["to": walletAddress, "id": id, "uri": tempImgUrl]
        let url = "https://kip17-api.klaytnapi.com/v1/contract/galleryxtoken/token"
        let headers : HTTPHeaders = [ "Content-Type": "application/json", "X-Chain-Id": "1001"]
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                   
                    let responseDict = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] as NSDictionary?
                    
                case .failure(let error):
                    print(error.localizedDescription, error)
                    
                }
                completionHandler()
        }
    }
    
    func makeContract(completionHandler:  @escaping () -> ()){
        let param = ["alias": "galleryxtoken", "symbol": "GXT", "name":"Gallery X Token"]
        let url = "https://kip17-api.klaytnapi.com/v1/contract"
        let headers : HTTPHeaders = [ "Content-Type": "application/json", "X-Chain-Id": "1001"]
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                   
                    let responseDict = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] as NSDictionary?
                    print(responseDict)
                   

                    
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
                completionHandler()
        }
    }
    
    func lookupToken(completionHandler:  @escaping () -> ()){
        let url = "https://kip17-api.klaytnapi.com/v1/contract/galleryxtoken/token/0x101"
        let headers : HTTPHeaders = ["Content-Type": "application/json", "X-Chain-Id": "1001"]
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                   
                    let responseDict = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] as NSDictionary?
                    print(responseDict)
                   

                    
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
                completionHandler()
        }
    }
    func getURL(img:UIImage){
        imgcount+=1
        let imageData = img.pngData()
        let storageRef = Storage.storage().reference().child(String(imgcount)+".jpg")
        if let uploadData = imageData{
            storageRef.putData(uploadData, metadata: nil
            , completion: { (metadata, error) in
               
                if error != nil {
                   
                    print("error")
                    print(error)
                    
                }else{
                    storageRef.downloadURL(completion: { (url, error) in
                        print("Image URL: \(url!)")
                        self.tempImgUrl = (url?.absoluteString)!
                        self.mintToken {
                            self.spinner.removeFromSuperview()
                            print(self.tokenId)
                            self.alert2Message = "Your token id is: " + self.tokenId
                            self.alert2 = UIAlertController(title: "GXT Minted", message: self.alert2Message, preferredStyle: .alert)
                            self.alert2.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: {(alert: UIAlertAction!) in self.navigationController?.popToRootViewController(animated: true)
                                                                    items.insert(self.UploadedImage.image ?? UIImage(), at: 0)}))
                            self.present(self.alert2, animated: true)
                            
                        }
                    })
                }
                
            })
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any]){
        
        if let image = info[UIImagePickerController.InfoKey(rawValue:"UIImagePickerControllerEditedImage")] as? UIImage {
            UploadedImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

