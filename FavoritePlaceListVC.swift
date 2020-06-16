//
//  FavoritePlaceListVC.swift
//  toVisitPlaces_Manpreetkaur_C0777685
//
//  Created by user175413  on 15/06/20.
//  Copyright © 2020 user175413 . All rights reserved.
//
import UIKit
import MapKit

class PlacesTVC: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var CityLbl: UILabel!
    @IBOutlet weak var localityLbl: UILabel!
    @IBOutlet weak var PostalLbl: UILabel!
    @IBOutlet weak var latlongLabel: UILabel!

}


class FavoritePlaceListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    var favoritePlaceArr = NSMutableArray()
    
       // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView =  UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let favArr = UserDefaults.standard.object(forKey:"FavPlaces")  {
            self.favoritePlaceArr = (favArr as! NSArray).mutableCopy() as! NSMutableArray
            tableView.reloadData()
                   
        }
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoritePlaceArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell : PlacesTVC = tableView.dequeueReusableCell(withIdentifier: "PlacesTVC", for: indexPath as IndexPath) as! PlacesTVC
        let dic = favoritePlaceArr[indexPath.row]
        
        cell.countryLabel.text = "Country : \((dic as! NSDictionary).value(forKey: "Country") as! String)"
        cell.CityLbl.text = "City : \((dic as! NSDictionary).value(forKey: "city") as! String)"
        cell.PostalLbl.text = "Postal : \((dic as! NSDictionary).value(forKey: "PostalCode") as! String)"
        cell.localityLbl.text = "Locality : \((dic as! NSDictionary).value(forKey: "Locality") as! String)"
    
        cell.latlongLabel.text = "lat : \((dic as! NSDictionary).value(forKey: "lat")!) \nlong : \((dic as! NSDictionary).value(forKey:"long")!)";
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.favoritePlaceArr.removeObject(at: index.row)
            UserDefaults.standard.set(self.favoritePlaceArr, forKey: "FavPlaces")
            if let favArr = UserDefaults.standard.object(forKey:"FavPlaces")  {
                self.favoritePlaceArr = (favArr as! NSArray).mutableCopy() as! NSMutableArray
                                          
            }
            
            self.tableView.reloadData()
            
        }
        delete.backgroundColor = .orange

        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
         let dic = favoritePlaceArr[indexPath.row]
         let lat = (dic as! NSDictionary).value(forKey: "lat")!
         let long  = (dic as! NSDictionary).value(forKey: "long")!
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.destination =  CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
        vc.indexNo = indexPath.row;
        vc.comesFrom = "PlacesScreen"
        navigationController?.pushViewController(vc,animated: true)
        
    }

}
