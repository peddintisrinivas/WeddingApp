//
//  LunchViewController.m
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


#import "LunchViewController.h"
#import "RouteViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "RouteVC.h"
#import "UConstants.h"

@interface LunchViewController ()
<CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    CLLocation *currentlocation;
    NSMutableArray *sourceArray;
}
@end

@implementation LunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sourceArray=[[NSMutableArray alloc]init];
    _backGroundView.alpha = 0;
    [UIView animateWithDuration:1.0
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
    
    //[[NSString stringWithFormat:@"%@",@"25.059882200000000000"]floatValue],[[NSString stringWithFormat:@"%@",@"55.244565999999960000"]floatValue]
    
    if ([self isMyAppInstalled]) {
        if ([[UIApplication sharedApplication] canOpenURL:
                 [NSURL URLWithString:@"comgooglemaps://"]]) {
                [[UIApplication sharedApplication] openURL:
                [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%@&directionsmode=driving",[NSString stringWithFormat:@"%@,%@,%@",@"Miracle+Garden",@"Dubai+Land+Project",@"Dubai"]]]];
            }
        }
    
     else {
       // NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f&zoom=14&mapmode=streetview", 28.50136857, 77.18506272,28.5433056,77.20677490000003];
        
       // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
        [self performSegueWithIdentifier:@"RouteSegue" sender:nil];

    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"RouteSegue"])
    {
        RouteVC *showRout=[segue destinationViewController];
//        showRout.dest_Lat=[[NSString stringWithFormat:@"%@",@"25.059882200000000000"]floatValue];
//        showRout.dest_Long=[[NSString stringWithFormat:@"%@",@"55.244565999999960000"]floatValue];
        showRout.addressStr=[NSString stringWithFormat:@"%@,%@,%@",@"Miracle+Garden",@"Dubai+Land+Project",@"Dubai"];
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
