//
//  UnityViewController.swift
//  GalleryX
//
//  Created by Won Woo Nam on 9/24/21.
//

import Foundation
import UIKit

class UnityViewController: UIViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.initAndShowUnity()
        UnityEmbeddedSwift.showUnity()
        let uView = UnityEmbeddedSwift.getUnityView() ?? UIView()
        //let num = self.view.subviews.count
        uView.frame = CGRect(x: 0, y: 0, width: uView.frame.height, height: uView.frame.width)
        self.view.addSubview(uView)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //Unity.shared.show()
    }
    
    
}
