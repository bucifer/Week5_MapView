//
//  MapViewController.m
//  Week 5 MapView Terry
//
//  Created by Aditya Narayan on 9/25/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import "MapViewController.h"
#import "WebViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myMapView.delegate = self;
    //you need to set the delegate of the mapview to the Viewcontroller so that the Viewcontroller starts listening to all the mapview's delegeate methods - i forgot this and that's why its update methods didn't work
    
//    I thought i needed CLLocationManager for htis problem .. but no! MapKit takes cares of everything
//    self.locationManager = [[CLLocationManager alloc]init];
//    [self.locationManager setDelegate:self];
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    self.myMapView.showsUserLocation = YES;

    //Place a single pin on TurnToTech
    MKPointAnnotation *TTTannotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D TTTCoordinate;
    TTTCoordinate.latitude = 40.741444;
    TTTCoordinate.longitude = -73.990070;
    [TTTannotation setCoordinate:TTTCoordinate];
    [TTTannotation setTitle:@"TurnToTech"];
    TTTannotation.subtitle = @"Subtitle: TurnToTech Office is here!!!!";
    [self.myMapView addAnnotation:TTTannotation];
    [self.myMapView selectAnnotation:TTTannotation animated:YES];
}


- (void)requestDataFromAPI:(MKUserLocation *)userLocation {
    //initialize your responseData here
    self.responseData = [NSMutableData data];
    
    NSString *myAPIKey = @"AIzaSyCdMoZiea0Z96EhH8cc3No7KJHv2rjey_c";
    
    NSString *requestString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&types=restaurant&opennow=1&key=%@", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude, myAPIKey];
    
    NSURL *APIRequestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:APIRequestURL];
    request.HTTPMethod = @"GET";
    //Fire the request you made before
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest: request delegate: self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentMapSelection:(id)sender {
    
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            self.myMapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.myMapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.myMapView.mapType = MKMapTypeSatellite;
            break;
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000);
    //you can set zoom to 50000 on each to make it nicely zoomed out
    [self.myMapView setRegion:region animated:YES];
    
    //Place a single pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:userLocation.coordinate];
    [annotation setTitle:@"You are here"];
    annotation.subtitle = @"GPS say that you are here";
    
    [self.myMapView addAnnotation:annotation];
    [self.myMapView selectAnnotation:annotation animated:YES];
    
    [self requestDataFromAPI:userLocation];
}

#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse *)response {
    //this handler, gets hit ONCE

}

- (void)connection: (NSURLConnection *)connection didReceiveData:(NSData *) data {
    //this handler, gets hit SEVERAL TIMES
    //Append new data to the instance variable everytime new data comes in
    
    [self.responseData appendData:data];

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    //Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //this handler gets hit ONCE
    // The request is complete and data has been received
    // You can parse the stuff in your data variable now or do whatever you want

    NSLog(@"connection finished");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    //Convert your responseData object
    NSError *myError = nil;
    NSDictionary *responseDataInNSDictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSArray *resultsArray = [responseDataInNSDictionary objectForKey:@"results"];
    for (int i=0; i < resultsArray.count; i++) {
        NSDictionary *restaurantObject = resultsArray[i];
        NSString *restaurantName = [restaurantObject objectForKey:@"name"];
        NSLog(@"%@", restaurantName);
        NSDictionary *geometryObject = [restaurantObject objectForKey:@"geometry"];
        NSDictionary *locationObject = [geometryObject objectForKey:@"location"];
        NSLog(@"%@ %@", [locationObject objectForKey:@"lat"], [locationObject objectForKey:@"lng"]);
        
        //Place the pin on these restaurants
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        
        CLLocationCoordinate2D restaurantCoordinate = CLLocationCoordinate2DMake([[locationObject objectForKey:@"lat"] doubleValue], [[locationObject objectForKey:@"lng"] doubleValue]);
        
        [annotation setCoordinate:restaurantCoordinate];
        [annotation setTitle:restaurantName];
        
        annotation.subtitle = [restaurantObject objectForKey:@"icon"];
        
        [self.myMapView addAnnotation:annotation];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


@end
