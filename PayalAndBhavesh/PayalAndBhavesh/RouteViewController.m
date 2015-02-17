//
//  RouteViewController.m
//  PayalAndBhavesh
//
//  Created by srinivas on 1/23/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#import "RouteViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"


@interface RouteViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView *routemapView;
    GMSPolyline *polyline;
    NSMutableArray *coordinates;
    AppDelegate *appDelegate;

}
@end

@implementation RouteViewController
@synthesize currentlocation,locationManager;

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy

    [locationManager startUpdatingLocation];  //requesting location updates
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestAlwaysAuthorization];
    }

    UIView *subview=[[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentlocation.coordinate.latitude
//                                                            longitude:currentlocation.coordinate.longitude zoom:6
//                                                              bearing:0
//                                                         viewingAngle:0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:17.881672
                                                                            longitude:78.554574699 zoom:6
                                                                                              bearing:0
                                                                                        viewingAngle:0];

    
    routemapView = [GMSMapView mapWithFrame:subview.bounds camera:camera];
    routemapView.clipsToBounds=NO;
    routemapView.myLocationEnabled=YES;
    routemapView.delegate=self;
    GMSMarker *marker = [[GMSMarker alloc] init];
    //marker.snippet = self.destinationTitle;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = routemapView;
    [subview addSubview:routemapView];
    [self.view addSubview:subview];
    routemapView.settings.myLocationButton = YES;
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(17.881672,78.554574699);
    GMSMarker *location = [GMSMarker markerWithPosition:position];
    location.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    location.position=position;
    location.icon = [UIImage imageNamed:@"tasklist_cookicon"];
    location.map = routemapView;
   // location.userData = @{@"title":[routeDict objectForKey:@"cook_name"],
                         // @"address":[routeDict objectForKey:@"cook_complete_address"]};
    
    
    CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake(17.3616723,78.474574699);
    GMSMarker *location1 = [GMSMarker markerWithPosition:position1];
    location1.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    location1.position=position1;
    location1.icon = [UIImage imageNamed:@"tasklist_usericon"];
    location1.map = routemapView;
   // location1.userData = @{@"title":[routeDict objectForKey:@"delivery_to_name"],
                           //@"address":[routeDict objectForKey:@"customer_complete_address"]};
    
    
    [self performSelectorInBackground:@selector(backgroundThread) withObject:nil];
   
   // NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@,%@", mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude, destinationLatitude, destinationLongtitude];
    
    

}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        UIAlertView* curr1=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [curr1 show];
    }
    else
    {
        UIAlertView* curr2=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        curr2.tag=121;
        [curr2 show];
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentlocation = [locations lastObject];
}

-(void)backgroundThread
{
    
    [self addLat:17.881672 sourcelongitude:78.554574699 destinationLat:17.3616723 destinationLog:78.474574699];
    
  //  [appDelegate showActivityView:@""];
    //[self addLat:[[routeDict objectForKey:@"cook_latitude"] floatValue] sourcelongitude:[[routeDict objectForKey:@"cook_longitude"] floatValue] destinationLat:[[routeDict objectForKey:@"delivery_to_latitude"] floatValue]destinationLog:[[routeDict objectForKey:@"delivery_to_longitude"] floatValue]];
    
}


-(void)addLat:(float)sourcelat sourcelongitude:(float)sourcelatlng destinationLat:(float)destinationLat destinationLog:(float)destinationLog
{
    
    NSString *urlstring= [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",[NSString stringWithFormat:@"%f,%f",sourcelat,sourcelatlng],[NSString stringWithFormat:@"%f,%f",destinationLat,destinationLog]];
    
    NSURL *googleRequestURL=[NSURL URLWithString:urlstring];
    NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
    if(data!=nil)
    {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              
                              options:kNilOptions
                              
                              error:nil];
        
        if ([[json objectForKey:@"status"] isEqualToString:@"OK"]) {
            
            //directions = [json objectForKey:@"results"];
            
            GMSMutablePath *path = [GMSMutablePath path];
            //                   [path addLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude]; // Fiji
            //                   [path addLatitude:latitude longitude:longitude]; // Sydney
            
            
            NSMutableArray *polyLinesArray = [[NSMutableArray alloc] init];
            
            int zero=0;
            NSArray *steps = [[[[[json objectForKey:@"routes"] objectAtIndex:zero] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
            for (int i=0; i<[[[[[[json objectForKey:@"routes"] objectAtIndex:zero] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"]count]; i++) {
                NSString* encodedPoints =[[[steps objectAtIndex:i]objectForKey:@"polyline"]valueForKey:@"points"];
                polyLinesArray = [self decodePolyLine:encodedPoints];
                NSUInteger numberOfCC=[polyLinesArray count];
                for (NSUInteger index = 0; index < numberOfCC; index++) {
                    CLLocation *location = [polyLinesArray objectAtIndex:index];
                    CLLocationCoordinate2D coordinate = location.coordinate;
                    [path addLatitude:coordinate.latitude longitude:coordinate.longitude];
                    if (index==0) {
                        [coordinates addObject:location];
                    }
                }
            }
            
            polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeColor = [UIColor colorWithRed:255.0f/255.0f green:210.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
            polyline.strokeWidth = 5.f;
            
            polyline.map = routemapView;
            
            //[appDelegate hideActivityView];
            
        }
        else {
            
            NSLog(@"status = %@",[json objectForKey:@"status"]);
        }
        
    }
    
}

-(IBAction)backBtnTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    
    [encoded replaceOccurrencesOfString:@"\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
