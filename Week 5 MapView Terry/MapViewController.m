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

    self.myMapView.showsUserLocation = YES;
    
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




@end
