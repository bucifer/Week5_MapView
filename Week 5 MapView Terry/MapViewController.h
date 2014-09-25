//
//  MapViewController.h
//  Week 5 MapView Terry
//
//  Created by Aditya Narayan on 9/25/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>

@property CLLocationManager *locationManager;




@end
