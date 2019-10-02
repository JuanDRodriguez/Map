//
//  FirstViewController.swift
//  Maps
//
//  Created by Pronto on 10/1/19.
//  Copyright © 2019 Pronto. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class FirstViewController: UIViewController {
      var locationManager = CLLocationManager()
      var currentLocation: CLLocation?
      var mapView: GMSMapView!
      var placesClient: GMSPlacesClient!
      var zoomLevel: Float = 15.0
        let infoMarker = GMSMarker()

      // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []{
        didSet{
            ModelData.shared.items = likelyPlaces
        }
    }

      // The currently selected place.
      var selectedPlace: GMSPlace?

      // A default location to use when location permission is not granted.
      let defaultLocation = CLLocation(latitude: 19.41187, longitude: -99.1734074)

      // Update the map once the user has made their selection.
      
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
           locationManager.requestWhenInUseAuthorization()
        }
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        //mapView.isHidden = true

        listLikelyPlaces()
      }

      // Populate the array with the list of likely places.
      func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()

        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
          if let error = error {
            // TODO: Handle the error.
            print("Current Place error: \(error.localizedDescription)")
            return
          }

          // Get likely places and add to the list.
          if let likelihoodList = placeLikelihoods {
            for likelihood in likelihoodList.likelihoods {
                let place = likelihood.place
                              self.likelyPlaces.append(place)
                ModelData.shared.items.append(place)
            }
          }
        })
      }

      // Prepare the segue.
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelect" {
         
        }
      }
    }

    // Delegates to handle events for the location manager.
    extension FirstViewController: CLLocationManagerDelegate {

      // Handle incoming location events.
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)

        if mapView.isHidden {
          mapView.isHidden = false
          mapView.camera = camera
        } else {
          mapView.animate(to: camera)
        }

        listLikelyPlaces()
      }

      // Handle authorization for the location manager.
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
          print("Location access was restricted.")
        case .denied:
          print("User denied access to location.")
          // Display the map using the default location.
          mapView.isHidden = false
        case .notDetermined:
          print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
          print("Location status is OK.")
        }
      }

      // Handle location manager errors.
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
      }
    }

extension FirstViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }
    
}
