import Foundation
import UIKit
import FirebaseStorage

public var items : [UIImage] = []
public var count = 140
public var imgcount = 4

class MainViewController: UIViewController {

    @IBOutlet weak var UploadNewImage: UIButton!
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    @IBOutlet weak var BlueprintImage: UIImageView!
    @IBOutlet weak var FirstImageView: UIImageView!
    @IBOutlet weak var SecondImageView: UIImageView!
    @IBOutlet weak var ThirdImageView: UIImageView!
    
    
    @IBOutlet weak var QRButton: UIButton!
    @IBOutlet weak var VRButton: UIButton!
    
    var selectedFinger = 0
    
    var imageViewItems : [UIImageView] = []
    var documentsUrl: URL {
        return FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let first  = UIImage(named: "1.jpg")!
        let second =  UIImage(named: "2.jpg")!
        let third =  UIImage(named: "3.jpg")!
        //items.append(first)
        //items.append(second)
        //items.append(third)
 
        //ImageCollectionView.layer.borderWidth = 2
        //ImageCollectionView.layer.borderColor = CGColor(red: 167/255, green: 155/255, blue: 135/255, alpha: 1.0)
        
        setDragAndDropSettings()
      
        ImageCollectionView.dataSource = self
        ImageCollectionView.delegate = self
        
        if let flowLayout = ImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            
        }
        
        ImageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 60)
        
        UploadNewImage.layer.cornerRadius = 5
        
        QRButton.layer.cornerRadius = 20
        VRButton.layer.cornerRadius = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("hihi")
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.topItem?.title = "Corgi Gallery"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        ImageCollectionView.reloadData()
        
    }
    
    func setDragAndDropSettings(){
        let dragInteraction1 = UIDragInteraction(delegate: self)
        dragInteraction1.isEnabled = true
        
        let dragInteraction2 = UIDragInteraction(delegate: self)
        dragInteraction2.isEnabled = true
        
        let dragInteraction3 = UIDragInteraction(delegate: self)
        dragInteraction3.isEnabled = true
        
        let dropInteraction1 = UIDropInteraction(delegate: self)
        let dropInteraction2 = UIDropInteraction(delegate: self)
        let dropInteraction3 = UIDropInteraction(delegate: self)
        
        ImageCollectionView.dragDelegate = self
        ImageCollectionView.dragInteractionEnabled = true
    
        
        FirstImageView.isUserInteractionEnabled = true
        SecondImageView.isUserInteractionEnabled = true
        ThirdImageView.isUserInteractionEnabled = true
        
        self.view.isUserInteractionEnabled = true
//        subView.isUserInteractionEnabled = true
//        imageView.isUserInteractionEnabled = true
        
        //Add Drop interaction for DropImageView
        FirstImageView.addInteraction(dropInteraction1)
        SecondImageView.addInteraction(dropInteraction2)
        ThirdImageView.addInteraction(dropInteraction3)
    
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    @IBAction func UploadImage(_ sender: Any) {
        
    }
    @IBAction func onVRGalleryPress(_ sender: Any) {
        getURL(img: FirstImageView.image ?? UIImage(), name: "11.jpg")
        getURL(img: SecondImageView.image ?? UIImage(), name: "22.jpg")
        getURL(img: ThirdImageView.image ?? UIImage(), name: "33.jpg")
    }
    
    
    func getURL(img:UIImage, name: String){
        let imageData = img.pngData()
        let storageRef = Storage.storage().reference().child(name)
        if let uploadData = imageData{
            storageRef.putData(uploadData, metadata: nil
            , completion: { (metadata, error) in
               
                if error != nil {
                   
                    print("error")
                    print(error)
                    
                }else{
                    storageRef.downloadURL(completion: { (url, error) in
                        print("Image URL: \(url!)")
                        
                    })
                }
                
            })
        }
    }
    
    
    
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellID", for: indexPath) as! ImageCell
        cell.actualImageView.image = items[indexPath.row]
        imageViewItems.append(cell.actualImageView)
        print("second")
        
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        selectedFinger = indexPath.row + 1
        print("hi")
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
}

extension MainViewController: UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
            let location = session.location(in: self.view)
            let dropOperation: UIDropOperation?
            if session.canLoadObjects(ofClass: UIImage.self) {
                if  FirstImageView.frame.contains(location) {
                    dropOperation = .copy
                    selectedFinger = 1
                } else if  SecondImageView.frame.contains(location) {
                    dropOperation = .copy
                    selectedFinger = 2
                    
                } else if  ThirdImageView.frame.contains(location) {
                    dropOperation = .copy
                    selectedFinger = 3
                    
                } else {
                    dropOperation = .cancel
                    selectedFinger = 0
                }
            } else {
                dropOperation = .cancel
                selectedFinger = 0
            }
            return UIDropProposal(operation: dropOperation!)
        }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
            
        if session.canLoadObjects(ofClass: UIImage.self) {
            session.loadObjects(ofClass: UIImage.self) { (items) in
                if let images = items as? [UIImage] {
                    switch self.selectedFinger{
                        
                    case 1 :
                        self.FirstImageView.image = images.last
                        break
                        
                    case 2 :
                        self.SecondImageView.image = images.last
                        break
                        
                    case 3 :
                        self.ThirdImageView.image = images.last
                        break
                        
                    default:
                        print("exit")
                    }
                    
                }
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession){
            
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession){
        
    }
}


extension MainViewController: UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let imageView = interaction.view as? UIImageView{
            guard let image = imageView.image else {return []}
            let provider = NSItemProvider(object: image)
            let item = UIDragItem.init(itemProvider: provider)
            return[item]
        }
        return []
    }
    
    
}

class ImageCell : UICollectionViewCell{
    
   
    @IBOutlet weak var actualImageView: UIImageView!
    
    
}
