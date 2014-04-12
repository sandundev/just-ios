//
//  ViewController.h
//  JustDelivery
//
//  Created by Sandun Lewke Bandara on 06/04/2014.
//  Copyright (c) 2014 Sandun Lewke Bandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)refreshTapped:(id)sender;

@end
