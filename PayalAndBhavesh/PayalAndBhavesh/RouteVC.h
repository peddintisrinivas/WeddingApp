//
//  RouteVC.h
//  PayalAndBhavesh
//
//  Created by srinivas on 1/27/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteVC : UIViewController
@property(nonatomic,retain)IBOutlet UIWebView *routeView;
@property(nonatomic,assign)float dest_Lat,dest_Long;

@property(nonatomic,strong)NSString *addressStr;


@end
