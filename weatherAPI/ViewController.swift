//
//  ViewController.swift
//  weatherAPI
//
//  Created by Alan Van Art on 2/12/20.
//  Copyright © 2020 Alan Van Art. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let api_key = "1a803c6d19763d2067ca9953d3b3526c"
    
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtResult: UILabel!
    @IBOutlet weak var imgWx: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // https://api.openweathermap.org/data/2.5/forecast?q=state%20college&APPID=1a803c6d19763d2067ca9953d3b3526c
        
        txtResult.text = ""
        
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
                            
                            if(jsonResult["message"] as? String != "city not found") {
                                print(jsonResult["name"]!!)
                            }
                            
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
            }
        }

        task.resume()
    }

}

