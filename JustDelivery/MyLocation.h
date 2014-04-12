//
//  MyLocation.h
//  JustDelivery
//
//  Created by Sandun Lewke Bandara on 06/04/2014.
//  Copyright (c) 2014 Sandun Lewke Bandara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end