//
//  MapViewController.m
//  Week 5 MapView Terry
//
//  Created by Aditya Narayan on 9/25/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myImageView.image = [UIImage imageNamed:@"bulbasaur.png"];
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];

    
    self.myMapView.showsUserLocation = YES;

    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.myMapView.userLocation.location.coordinate.latitude; // your latitude value
    zoomLocation.longitude= self.myMapView.userLocation.location.coordinate.latitude; // your longitude value
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span = MKCoordinateSpanMake(50, 50);
    region.span=span;
    region.center= zoomLocation;
    [self.myMapView setRegion:region animated:TRUE];

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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

        CLLocation *loc = [locations lastObject];
        CLLocationCoordinate2D location = [loc coordinate];
        
        //      set center the map at the current position
        MKCoordinateRegion region           = MKCoordinateRegionMakeWithDistance(location, 400, 400);
    
        NSLog(@"Updating Location to %f %f", location.latitude, location.longitude);
    
        [self.myMapView setRegion: region animated:YES];

}

@end
