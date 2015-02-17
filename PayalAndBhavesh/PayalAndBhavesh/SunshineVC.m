//
//  SunshineVC.m
//  PayalAndBhavesh
//
//  Created by srinivas on 1/22/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#define SNOW_IMAGENAME         @"snow"

#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25


#import "SunshineVC.h"
#import "SWRevealViewController.h"
#import "RouteVC.h"
#import "UConstants.h"
#import "CoreLocation/CoreLocation.h"





@interface SunshineVC ()<CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    CLLocation *currentlocation;
}
@property(nonatomic,retain)IBOutlet UIView *backGroundView;

@end

@implementation SunshineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backGroundView.alpha = 0;
    [UIView animateWithDuration:2.0
                     animations:^{
                         _backGroundView.alpha = 0.65;
                     }
                     completion:^(BOOL finished){
                         // Do other things
                     }];

    //[self startShowFall];
    
    if([CLLocationManager locationServicesEnabled]){
        currentlocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentlocation = [locations objectAtIndex:0];
    
}

-(IBAction)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startShowFall
{
    // Do any additional setup after loading the view, typically from a nib.
    _imagesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; ++ i) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(SNOW_IMAGENAME)];
        float x = IMAGE_WIDTH;
        imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
        imageView.alpha = IMAGE_ALPHA;
        [self.view addSubview:imageView];
        [_imagesArray addObject:imageView];
    }
    [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    
}
static int i = 0;
- (void)makeSnow
{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
    
}

- (void)snowFall:(UIImageView *)aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:6];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)isMyAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
}

-(IBAction)showRoute:(id)sender{
   if ([self isMyAppInstalled]) {
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         //Umm Suqeim Fishing Harbour - Dubai - United Arab Emirates

         //The Lebanon Island, World Island Project, Dubai, UAE
    [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%@&directionsmode=driving",[NSString stringWithFormat:@"%@,%@,%@",@"Umm+Suqeim+Fishing+Harbour",@"Dubai",@"UAE"]]]];
        
        //[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&zoom=14&mapmode=streetview",[NSString stringWithFormat:@"%@,%@,%@,%@,%@",@"The+Meydan+Arena",@"Bab+Al+Shams",@"Qudra+Road",@"Dubai",@"UAE"],[NSString stringWithFormat:@"%@,%@,%@",@"Umm+Suqeim+Fishing+Harbour",@"Dubai",@"UAE"]]]];
        
               
        // [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@,%@&daddr=%f,%f&zoom=14&mapmode=streetview",[NSString stringWithFormat:@"%.8f",currentlocation.coordinate.latitude], [NSString stringWithFormat:@"%.8f",currentlocation.coordinate.longitude],[[NSString stringWithFormat:@"%@",@"25.226384"]floatValue],[[NSString stringWithFormat:@"%@",@"55.169510"]floatValue]]]];
         
       
    }
    } else {
        //        NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f&zoom=14&mapmode=streetview", 28.50136857, 77.18506272,28.5433056,77.20677490000003];
        //
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
        [self performSegueWithIdentifier:@"RouteSegue" sender:nil];
        
    }

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"RouteSegue"])
    {
        RouteVC *showRout=[segue destinationViewController];
//        showRout.dest_Lat=[[NSString stringWithFormat:@"%@",@"25.226384"]floatValue];
//        showRout.dest_Long=[[NSString stringWithFormat:@"%@",@"55.169510"]floatValue];

    showRout.addressStr=[NSString stringWithFormat:@"%@,%@,%@",@"Umm+Suqeim+Fishing+Harbour",@"Dubai",@"UAE"];

    }
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
