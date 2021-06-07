//
//  ViewController.swift
//  TakeHome
//
//  Created by Nehal Patel on 04/02/1943 Saka.
//

import UIKit
import CoreLocation
import Charts

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //global Labels
    @IBOutlet weak var gTotal: UILabel!
    @IBOutlet weak var gDeaths: UILabel!
    @IBOutlet weak var gRecovered: UILabel!
    
    //percentage Labels
    @IBOutlet weak var pTotal: UILabel!
    @IBOutlet weak var pDeaths: UILabel!
    @IBOutlet weak var pCountry: UILabel!
    
    //Country Labels
    @IBOutlet weak var cTotal: UILabel!
    @IBOutlet weak var cRecovered: UILabel!
    @IBOutlet weak var cDeaths: UILabel!
    @IBOutlet weak var cCountry: UILabel!
    
    //chartview
    @IBOutlet weak var chartview: PieChartView!
    
    
    // Piechart Values
    var chartTotal = PieChartDataEntry(value: 0)
    var chartDeaths = PieChartDataEntry(value: 0)
    var dataEntries = [PieChartDataEntry]()
    
    //location manager
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartview.chartDescription.text = ""
        
        //location Data
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        getGlobalCovid()
    }
    
    func getGlobalCovid(){
        //call api for global
        let session = URLSession.shared
        let url = "https://corona.lmao.ninja/v2/all?yesterday"
        
        let gUrl = URL(string: url)!
        
        let task = session.dataTask(with: gUrl){ data,response,error in
            
            if error != nil || data == nil {
                print("Client error")
                return
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else{
                print("Server error")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else{
                print("Incorrect Mime Type")
                return
            }
            
            do{
                let readAllCovid = try JSONSerialization.jsonObject(with: data!, options: [] ) as! [String:Any]
                
                //Totalcases, deaths, recovered Globally
                let cases = readAllCovid["cases"]  as! Int
                let deaths = readAllCovid["deaths"] as! Int
                let recovered = readAllCovid["recovered"] as! Int
                
                //   print(cases,deaths,recovered)
                
                DispatchQueue.main.async {
                    
                    self.gTotal.text = "\(cases)"
                    self.gDeaths.text = "\(deaths)"
                    self.gRecovered.text = "\(recovered)"
                    
                }
                
            }catch{
                print("Error in YourSide")
            }
        }
        
        task.resume()
    }
    
    
    func getCountryCovid(country c:String){
        
        let session = URLSession.shared
        let url = "https://corona.lmao.ninja/v2/countries/\(c)?yesterday&strict&query%20"
        
        let cUrl = URL(string: url)!
        
        let task = session.dataTask(with: cUrl){ data,response,error in
            
            if error != nil || data == nil {
                print("Client error")
                return
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else{
                print("Server error")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else{
                print("Incorrect Mime Type")
                return
            }
            do{
                let readCountry = try JSONSerialization.jsonObject(with: data!, options: [] ) as! [String:Any]
                
                let cCases = readCountry["cases"] as! Int
                let cDeaths = readCountry["deaths"] as! Int
                let cRecovered = readCountry["recovered"] as! Int
                
                // print(cCases, cDeaths, cRecovered)
                
                DispatchQueue.main.async {
                    
                    self.cTotal.text = "\(cCases)"
                    self.cDeaths.text = "\(cDeaths)"
                    self.cRecovered.text = "\(cRecovered)"
                    
                    //Convert into Double valuess
                    let gDeathv = Double(self.gDeaths.text!)!
                    let gTotalv = Double(self.gTotal.text!)!
                    
                    //calculate percentage
                    
                    let pieTotal = Double(cCases) / gTotalv * 100
                    let pieDeath =  Double(cDeaths) / gDeathv * 100
                    
                    
                    //set label for percentages
                    self.pTotal.text = String(format: "%.2f", pieTotal ) + "%"
                    self.pDeaths.text = String(format: "%.2f", pieDeath ) + "%"
                    
                    self.chartUpdates(t: pieTotal , d: pieDeath)
                    
                    
                    
                    
                }
                
            }catch{
                print("Error in YourSide")
            }
        }
        
        task.resume()
    }
    
    
    func chartUpdates(t:Double, d:Double ){
        
        dataEntries = []
        
        self.chartTotal.label = "Total(%)"
        self.chartTotal.value = t
        
        self.chartDeaths.label = "Deaths(%)"
        self.chartDeaths.value = d
        
        dataEntries =  [chartDeaths, chartTotal]
        
        let set = PieChartDataSet(entries: dataEntries, label: "Dataset")
        
        set.colors = ChartColorTemplates.joyful()
        
        let chartData =  PieChartData(dataSet: set)
        chartview.drawHoleEnabled = true
        chartview.holeRadiusPercent = 0.3
        chartview.data = chartData
        
        
        
    }
    
    
    func countryName(Lat:Double, Lon:Double ){
        let session = URLSession.shared
        let url = "https://api.opencagedata.com/geocode/v1/json?q=\(Lat)+\(Lon)&key=d4e7047467594d95ae8f497c23e9516b"
        let nUrl = URL(string: url)!
        
        let task = session.dataTask(with: nUrl){ data,response,error in
            
            if error != nil || data == nil {
                print("Client error")
                return
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else{
                print("Server error")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else{
                print("Incorrect Mime Type")
                return
            }
            do{
                let readName = try JSONSerialization.jsonObject(with: data!, options: [] ) as! [String:Any]
                
                let results = readName["results"] as! [Any]
                
                let xData = results[0] as! [String:Any]
                
                let component = xData["components"] as! Dictionary<String,Any>
                
                let cName = component["country"] as! String
                
                DispatchQueue.main.async {
                    self.pCountry.text = "\(cName)"
                    self.cCountry.text = "\(cName)"
                    
                    self.getCountryCovid(country:cName)
                }
            }catch{
                print("Error in YourSide")
            }
        }
        
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        countryName(Lat: location.coordinate.latitude, Lon: location.coordinate.longitude)
        
        //stop frequently updates with same values
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}
