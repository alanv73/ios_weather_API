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

    override func viewDidLoad() {
        super.viewDidLoad()
       // https://api.openweathermap.org/data/2.5/forecast?q=state%20college&APPID=1a803c6d19763d2067ca9953d3b3526c
        
    
        
    }

    @IBAction func submit(_ sender: AnyObject) {
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=" + txtCity.text!.replacingOccurrences(of: " ", with: "%20") + "&appid=" + api_key) {
            
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    if let urlContent = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            print(jsonResult)
                            
                            print(jsonResult["name"]!!)
                            
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                DispatchQueue.main.sync(execute: {
                                    self.txtResult.text = description
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

}

