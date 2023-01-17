//
//  InfoSearchViewController.swift
//  CommonPlant_iOS
//
//  Created by hweyoung on 2023/01/16.
//

import UIKit

protocol TextFieldSearchDelegate{
    func onChange(text: String)
}

class InfoSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchInputLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    
    func onChange(text: String){
        searchInputLabel.text = text
    }
    
    
    
    
    //========검색 결과 리스트 table========
    func setupTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantInitialData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSearchTableViewCell", for: indexPath) as? InfoSearchTableViewCell else {return UITableViewCell()}
        
        let item = plantInitialData[indexPath.row]
        cell.setupData(
            item.plantImage,
            item.name,
            item.scientificName
        )
        return cell
    }
    

    //데이터 모델
    let plantInitialData:[plantInitialModel] = [
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera"),
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera"),
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera"),
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera"),
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera"),
        plantInitialModel(plantImage: UIImage(named: "InfoPlantImg"), name: "몬스테라", scientificName: "Monstera")
    ]
    
    //셀의 각 요소를 들고 있는 구조체
    struct plantInitialModel{
        let plantImage : UIImage?
        let name : String
        let scientificName : String
    }
}