//
//  ProfileViewController.swift
//  BeautyInventory
//
//  Created by Ling Ouyang on 12/11/16.
//  Copyright © 2016 Ling Ouyang. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces



class ProfileViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate ,UIAlertViewDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate,UINavigationControllerDelegate,WeatherGetterDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    

    @IBOutlet weak var mapView: GMSMapView!
    
    
    @IBOutlet weak var myImageView: UIImageView!
 
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var btnClickMe: UIButton!
    
    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var weatherLabel: UILabel!
    
 
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
     var popover:UIPopoverController?=nil
     var weather: WeatherGetter!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //weather = WeatherGetter(delegate: self)
        //weather.getWeather(lat: String(describing: curlatitude), long: String(describing: curlongtude) )
        
       
        
        cityLabel.text = "simple weather"
        weatherLabel.text = ""
        temperatureLabel.text = ""
        nameLabel.text = "Ling Ouyang"
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    // MARK: WeatherGetterDelegate methods
    // -----------------------------------
    
    func didGetWeather(weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async  {
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
       
                }
    }
    
    func didNotGetWeather(error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async  {
        self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
    
        func showSimpleAlert(title: String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "OK",
                style:  .default,
                handler: nil
            )
            alert.addAction(okAction)
            present(
                alert,
                animated: true,
                completion: nil
            )
        }
        

    
    @IBAction func btnImagePickerClicked(_ sender: Any) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        let picker = UIImagePickerController()
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.present(from: btnClickMe.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
     
    
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {   let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func openGallary()
    {   let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker)
                popover!.present(from: btnClickMe.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
           myImageView.image = image
        }
         else
        {
          print("error loading image")
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
   

    
    
    @IBAction func photolibraybutton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable (UIImagePickerControllerSourceType.photoLibrary)
        { let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
            
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(toLocation: location.coordinate)
        mapView.animate(toZoom: 16)
        
        
        let marker = GMSMarker(position: location.coordinate)
        marker.title = "current postion"
        marker.tracksViewChanges = true
        marker.map = mapView
        manager.stopUpdatingLocation()
        weather.getWeatherByCoordinates(latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
    }
 
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(coordinate: position.target)
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines
                self.addressLabel.text = lines?.joined(separator: "\n")
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
