//
//  ViewController.swift
//  weatherAPI
//
//  Created by Alan Van Art on 2/12/20.
//  Copyright © 2020 Alan Van Art. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let api_key = "1a803c6d19763d2067ca9953d3b3526c"
    
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtResult: UILabel!
    @IBOutlet weak var imgWx: UIImageView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblRealFeel: UILabel!
    @IBOutlet weak var lblTempLbl: UILabel!
    @IBOutlet weak var lblRealFeelLbl: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // https://api.openweathermap.org/data/2.5/forecast?q=state%20college&APPID=1a803c6d19763d2067ca9953d3b3526c
        
        txtResult.text = ""
        map.isHidden = true
        
    }

    @IBAction func submit(_ sender: AnyObject) {
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + txtCity.text!.replacingOccurrences(of: " ", with: "%20") + "&units=imperial&appid=" + api_key) {
            
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            print(jsonResult)
                            
                            if(jsonResult["message"]! == nil) {
                                print(jsonResult["name"]!!)
                                print(jsonResult["coord"]!!)
                            
                            
                                if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                    DispatchQueue.main.sync(execute: {
                                        self.txtResult.text = description
                                    })
                                }
                                if let icon = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["icon"] as? String {
                                    DispatchQueue.main.sync(execute: {
                                        self.getIcon(icon)
                                    })
                                }
                                
                                let mainCondx = jsonResult["main"]
                                
                                let realFeel = (mainCondx as! NSMutableDictionary)["feels_like"] as! Double
                                let temp = (mainCondx as! NSMutableDictionary)["temp"] as! Double
                                
                                
                                
                                print(temp)
                                
                                let location = jsonResult["coord"]
                                
                                let lat = (location as! NSMutableDictionary)["lat"]!
                                let lon = (location as! NSMutableDictionary)["lon"]!

                                DispatchQueue.main.sync(execute: {
                                    self.lblTemp.text = String(format: "%.1f", temp) + "°"
                                    self.lblTemp.isHidden = false
                                    self.lblTempLbl.isHidden = false
                                    self.lblRealFeel.text = String(format: "%.1f", realFeel) + "°"
                                    self.lblRealFeel.isHidden = false
                                    self.lblRealFeelLbl.isHidden = false
                                    self.showMap(lat as! Double, lon as! Double)
                                })

                            } else {
                                DispatchQueue.main.async {
                                    print(jsonResult["message"]!!)
                                    self.txtResult.text = (jsonResult["message"] as! String)
                                    self.map.isHidden = true
                                    self.imgWx.isHidden = true
                                    self.lblTemp.isHidden = true
                                    self.lblRealFeel.isHidden = true
                                    self.lblTempLbl.isHidden = true
                                    self.lblRealFeelLbl.isHidden = true
                                }
                            }
                            
                        } catch {
                            print("JSON Processing Failed")
                        }
                    }
                }
            }
            task.resume()
        } else {
            txtResult.text = "City not found"
        }
        
        
    }
    
    func getIcon (_ icon: String) {
        print("http://openweathermap.org/img/wn/\(icon)@2x.png")
        
        let url = URL(string:"http://openweathermap.org/img/wn/\(icon)@2x.png")

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {    // execute on main thread
                self.imgWx.image = UIImage(data: data)
                self.imgWx.isHidden = false
            }
        }

        task.resume()
    }
    
    func showMap(_ lat: Double, _ lon: Double) {
        map.isHidden = false
        
        let latitude: CLLocationDegrees = lat //40.775074
        let longitude: CLLocationDegrees = lon //-77.855720
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
        
        
    }

}

