//
//  RouteViewController.h
//  PayalAndBhavesh
//
//  Created by srinivas on 1/23/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RouteViewController : UIViewController
{
    CLLocationManager * locationManager;
    CLLocation *currentlocation;
    
}
@property (strong, nonatomic)CLLocationManager * locationManager;
@property (strong, nonatomic)CLLocation *currentlocation;
@property (strong, nonatomic)IBOutlet UIWebView *routeView;

@end
