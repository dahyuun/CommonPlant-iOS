//
//  MainViewController.swift
//  CommonPlant_iOS
//
//  Created by 이예원 on 2023/01/14.
//

import UIKit
import Alamofire

class MainVC: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var mainPlaceCollectionView: UICollectionView!
    @IBOutlet weak var mainPlantCollectionView: UICollectionView!
    @IBOutlet weak var addPlaceBtn: UIButton!
    
    var myGardenList: [MyGardenResult] = []
    
    var placeImgArray = [
        UIImage(named: "place1.png"),
        UIImage(named: "place2.png"),
        UIImage(named: "place3.png"),
        UIImage(named: "place4.png")
    ]
    
    
    var plantImgArray = [
        UIImage(named: "plant1.png"),
        UIImage(named: "plant2.png"),
        UIImage(named: "plant3.png"),
        UIImage(named: "plant4.png"),
        UIImage(named: "plant5.png")
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData() { response in
            self.myGardenList.append(response)
            self.userName.text = self.myGardenList.first?.nickName

            let plantImgUrl = URL(string: self.myGardenList.first?.plantList.first?.imgUrl ?? "")
            print("==========plantImgUrl: \(plantImgUrl)=========")


        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUpGradient()
        mainPlaceCollectionView.delegate = self
        mainPlaceCollectionView.dataSource = self
        mainPlaceCollectionView.register(UINib(nibName: "MainPlaceCVC", bundle: nil), forCellWithReuseIdentifier: "MainPlaceCVC")
        
        mainPlantCollectionView.delegate = self
        mainPlantCollectionView.dataSource = self
        mainPlantCollectionView.register(UINib(nibName: "MainPlantCVC", bundle: nil), forCellWithReuseIdentifier: "MainPlantCVC")
    }
    
    func setAttributes() {
        
        
        //친구요청 버튼 처리
        
    }
    
    func setUpGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = gradationView.bounds
        let colors: [CGColor] = [
            UIColor(red: 0.847, green: 0.871, blue: 0.867, alpha: 0.6).cgColor,
            UIColor(red: 0.847, green: 0.871, blue: 0.867, alpha: 0).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradationView.layer.masksToBounds = true
        gradationView.layer.addSublayer(gradientLayer)
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainPlaceCollectionView {
            return myGardenList.first?.placeList.count ?? 1
        } else {
            return myGardenList.first?.plantList.count ?? 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainPlaceCollectionView {
            performSegue(withIdentifier: "addPlaceToMyPlace", sender: nil)
        } else {
            performSegue(withIdentifier: "myGardenToMyPlant", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainPlaceCollectionView {
            guard let placeCell = mainPlaceCollectionView.dequeueReusableCell(withReuseIdentifier: "MainPlaceCVC", for: indexPath) as? MainPlaceCVC else { return UICollectionViewCell() }
            let placeImgUrl = URL(string: self.myGardenList.first?.placeList[indexPath.row].imgUrl ?? "https://firebasestorage.googleapis.com/v0/b/common-plant.appspot.com/o/commonPlant_plant_몬테_fSfdkw?alt=media")
            print("***********placeImgUrl: \(placeImgUrl)***********")
            
    //        placeCell.addPlaceImg.load(url: placeImgUrl!)
            
            placeCell.placeLabel.text = myGardenList.first?.placeList[indexPath.row].placeName
            
            return placeCell
        } else {
            guard let plantCell = mainPlantCollectionView.dequeueReusableCell(withReuseIdentifier: "MainPlantCVC", for: indexPath) as? MainPlantCVC else { return UICollectionViewCell() }
//            plantCell.addPlantImg.image = plantImgArray[indexPath.row]
//            plantCell.myPlantLabel.text = "My Plant"
            return plantCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainPlaceCollectionView {
            return CGSize(width: 250, height: 156)
        } else {
            return CGSize(width: 164, height: 108)
        }
    }
    
}

extension MainVC {
    func fetchData(completion: @escaping (MyGardenResult) -> Void){
        var accessToken: String = UserDefaults.standard.object(forKey: "token") as! String ?? ""
       // let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMWVkYWFjMi0zNTczLTE5Y2UtYjQ3OC0zNjUyOWM3OTFiOGQiLCJpYXQiOjE2NzYxOTcwMDIsImV4cCI6MTY3NjIyMjIwMn0.LvLJBOvYrZ3i_fjDjNTgDtOpz8qQfdlbnSjfufZQhGg"
   //     print("==================accessToken: \(accessToken)===================")
        var url = API.BASE_URL + "/place/myGarden"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let header : HTTPHeaders = [
            "X-AUTH-TOKEN": accessToken
        ]
        
        MyAlamofireManager.shared
            .session
            .request(url,method : .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseJSON(completionHandler: {response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

                        let myGardenData = try! JSONDecoder().decode(MyGardenModel.self, from: jsonData) 
                        print("==========myGardenData: \(myGardenData)=========")

                    //    let imgUrl = URL(string: myGardenData.result.placeList.first?.imgUrl ?? "")
                   //     print("==========imgUrl: \(imgUrl)=========")
                        
                        self.myGardenList.append(myGardenData.result)
                        completion(myGardenData.result)
                        
                        
                        DispatchQueue.main.async {
                            self.mainPlaceCollectionView.reloadData()
                            self.mainPlantCollectionView.reloadData()
                        }
//                        } else {
//                            print("======print jsonData=========")
//                            print(jsonData)
//                            print("======printed jsonData=========")
//                        }
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(_): break
                }
            })
    }
}

