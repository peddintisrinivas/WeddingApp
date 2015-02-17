//
//  RouteVC.m
//  PayalAndBhavesh
//
//  Created by srinivas on 1/27/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#import "RouteVC.h"
#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>



@interface RouteVC ()<CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    CLLocation *currentlocation;
    int x;
    CLLocationCoordinate2D location;
    NSDictionary *dict;
    CLGeocoder *geocoder;
    NSMutableArray *testArray;
}
@property (strong, nonatomic) NSString *street,*state,*country;

@end
@implementation RouteVC
@synthesize routeView;


- (void)viewDidLoad {
    [super viewDidLoad];
    testArray=[[NSMutableArray alloc]init];
    dict=[[NSDictionary alloc]init];
    if([CLLocationManager locationServicesEnabled]){
        currentlocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    x=0;
   
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
    }
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
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentlocation = [locations objectAtIndex:0];
    // [self addLat:17.881672 sourcelongitude:78.554574699 destinationLat:17.3616723 destinationLog:78.474574699];
    if (x==0)
    {
        [self loadMapAddress];
        x=x+1;
    }
  
}
-(void)loadMapAddress
{
    if(!geocoder)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    [geocoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSLog(@"Placemark array: %@",placemark.addressDictionary);
         //String to address
         if (placemark.addressDictionary!=nil) {
             [testArray addObject:placemark.addressDictionary];
         }
         
         NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location in the console
         NSLog(@"Currently address is: %@",locatedaddress);
         
         [self loadMapView];
     }];
    

}
-(void)loadMapView
{
    
    [self reverseGeocode:[NSValue valueWithMKCoordinate:locationManager.location.coordinate]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@&output=embed",[NSString stringWithFormat:@"%@,%@,%@",[[testArray objectAtIndex:0]objectForKey:@"Country"],[[testArray objectAtIndex:0]objectForKey:@"City"],[[testArray objectAtIndex:0]objectForKey:@"Name"]],_addressStr]
                  ];
    NSString *embedHTML = [NSString stringWithFormat:@"<iframe width=\"305 initial-scale=1.0 \" height=\"%f initial-scale=1.0 \" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>",self.view.bounds.size.height ,[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@&output=embed", [NSString stringWithFormat:@"%@,%@,%@",[[testArray objectAtIndex:0]objectForKey:@"Country"],[[testArray objectAtIndex:0]objectForKey:@"City"],[[testArray objectAtIndex:0]objectForKey:@"Name"]],_addressStr]];
    
    [routeView loadHTMLString:embedHTML baseURL:url];
    
    location=CLLocationCoordinate2DMake(_dest_Lat, _dest_Long);

 
}
- (void)reverseGeocode:(NSValue *)coordinatesValue
{
    
    CLLocationCoordinate2D locationCord = location;
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    CLLocation *curlocation = [[CLLocation alloc] initWithLatitude:locationCord.latitude longitude:locationCord.longitude];
    
    [geo reverseGeocodeLocation:curlocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *addressPlacmark = [placemarks firstObject];
        NSLog(@"%@",addressPlacmark.addressDictionary);
        dict=addressPlacmark.addressDictionary;
        if ([addressPlacmark.addressDictionary[@"City"] isEqualToString:@"Boston"] ||
            [addressPlacmark.addressDictionary[@"City"] isEqualToString:@"Chicago"] ||
            [addressPlacmark.addressDictionary[@"City"] isEqualToString:@"New York"] ||
            [addressPlacmark.addressDictionary[@"City"] isEqualToString:@"San Francisco"] ) {
            NSLog(@"Hurry!!! We got city %@",addressPlacmark.addressDictionary[@"City"]);
        }
        
        NSString *city = [NSString stringWithFormat:@"%@",addressPlacmark.locality];
        
        if (addressPlacmark.addressDictionary[@"SubThoroughfare"] && addressPlacmark.addressDictionary[@"Thoroughfare"]) {
            _street = [NSString stringWithFormat:@"%@ %@",addressPlacmark.addressDictionary[@"SubThoroughfare"], addressPlacmark.addressDictionary[@"Thoroughfare"]];
            
        }
        else
        {
            if (addressPlacmark.addressDictionary[@"Name"])
            {
                _street = addressPlacmark.addressDictionary[@"Name"];
            }
            if (addressPlacmark.addressDictionary[@"City"])
            {
                _street = [NSString stringWithFormat:@"%@, %@",_street, addressPlacmark.addressDictionary[@"City"]];
            }
        }
        
        _state = addressPlacmark.addressDictionary[@"State"];
        _country = addressPlacmark.addressDictionary[@"Country"];
        
        NSMutableDictionary *addressDictionary;
        @try {
            addressDictionary = [[NSMutableDictionary alloc] initWithObjects:@[_street, city] forKeys:@[@"street", @"city"]];
            
        }
        @catch (NSException *exception) {
            NSLog(@"No Internet");
        }
        
        if(_street)
        {
            NSString *address = [_street stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            
        }
        else
        {
            NSString *address = [[addressDictionary objectForKey:@"city"] stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if ([address isEqualToString:@""]) {
                address = @"Search Location";
            }
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backBtnTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
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
