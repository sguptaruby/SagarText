//
//  WeatherViewController.swift
//  SagarTest
//
//  Created by Apple on 30/08/20.
//  Copyright © 2020 Macmini. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblhumidity: UILabel!
    var viewmodal = WeatherViewModal()
    let todaysDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
        if let waitingDate:NSDate = UserDefaults.standard.value(forKey: "waitingDate") as? NSDate {
            if (todaysDate.compare(waitingDate as Date) == ComparisonResult.orderedDescending) {
                viewmodal.removeObjects()
            }
        }
    }
    
    
    
    func apiCalled(city:String) {
        viewmodal.searchCity = city
        self.showHUD()
        viewmodal.weather { (bool, weather, error) in
            self.hideHUD()
            if error == nil {
                self.lblTemp.text = "\(weather?.main.temp ?? 0)°"
                self.lblhumidity.text = "\(weather?.main.humidity ?? 0) Humidity"
            }else{
                self.showAlert(title: "Weather", message: error.debugDescription)
            }
        }
    }
    
}

extension WeatherViewController:UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        
        searchBar.text = nil
        self.lblTemp.text = "\(0)°"
        self.lblhumidity.text = "\(0) Humidity"
        searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
           let city = viewmodal.checkCity(city: text.uppercased())
            if city.exists {
                self.lblTemp.text = "\(city.weather.temp)°"
                self.lblhumidity.text = "\(city.weather.humidity) Humidity"
            }else{
                apiCalled(city: text)
            }
        }
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
