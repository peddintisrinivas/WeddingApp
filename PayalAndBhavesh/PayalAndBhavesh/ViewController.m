//
//  ViewController.m
//  PayalAndBhavesh
//
//  Created by srinivas on 1/21/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#define SNOW_IMAGENAME         @"snow"

#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "UConstants.h"

@interface ViewController ()<SWRevealViewControllerDelegate>
@property(nonatomic,retain)IBOutlet UIView *backGroundView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.menuBtn addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _backGroundView.alpha = 0;
    [UIView animateWithDuration:2.0
                     animations:^{
                         _backGroundView.alpha = 0.65;
                     }
                     completion:^(BOOL finished){
                         // Do other things
                     }];
    
   // [self startShowFall];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
