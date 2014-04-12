//
//  ViewController.m
//  JustDelivery
//
//  Created by Sandun Lewke Bandara on 06/04/2014.
//  Copyright (c) 2014 Sandun Lewke Bandara. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "MyLocation.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController



// Add new method above refreshTapped
- (void)plotCrimePositions:(NSData *)responseData {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }

    NSArray *personList= [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    for (NSDictionary *person in personList) {
        NSDictionary *currentLocation = person[@"currentLocation"];
         NSNumber * latitude = 0;
          NSNumber * longitude = 0;
       
            latitude = currentLocation[@"latitude"];
            longitude = currentLocation[@"longitude"];
        
        CLLocationCoordinate2D coordinate;
         coordinate.latitude = latitude.doubleValue;
         coordinate.longitude = longitude.doubleValue;
        NSString *description = latitude.description;
        NSString  *addressLine =  longitude.description;
        MyLocation *annotation = [[MyLocation alloc] initWithName:description address:addressLine coordinate:coordinate] ;
        [_mapView addAnnotation:annotation];
     
    }
 
}


- (IBAction)refreshTapped:(id)sender {
    // 1
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    // 2
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString,
                      centerLocation.latitude, centerLocation.longitude, 0.5*METERS_PER_MILE];
    
    // 3
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/com.justdelivery.api/api/person/list/1150"];
    
    // 4
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    // 5
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        
        // Add new line inside refreshTapped, in the setCompletionBlock, right after logging the response string
        [self plotCrimePositions:request.responseData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.5301676;
    zoomLocation.longitude= -0.1244155;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"red.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"green.png"];
        }
        
        return annotationView;
    }
    
    return nil;
}

@end
