//
//  MenuViewController.m
//  PayalAndBhavesh
//
//  Created by srinivas on 1/22/15.
//  Copyright (c) 2015 Mobikasa. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCustomTableViewCell.h"
#import "LunchViewController.h"
#import "SWRevealViewController.h"
#import "ArabianNightsVC.h"
#import "SunshineVC.h"
#import "VowsOfEternity.h"
#import "ViewController.h"

@interface MenuViewController ()
{
    NSMutableArray *titleArray;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray=[[NSMutableArray alloc]initWithObjects:@"The Celebrations",@"A Luncheon with Flora",@"Arabian Nights",@"Sunshine on My Shoulders",@"Vows of Eternity", nil];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - UITableView DataSource -
// Customize the number of sections in the table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MenuCellIdentifier";
    
    
    MenuCustomTableViewCell *cell = (MenuCustomTableViewCell *)[tableView
                                                                dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = (MenuCustomTableViewCell *)[[MenuCustomTableViewCell alloc]
                                           initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:210.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
    [cell setSelectedBackgroundView:bgColorView];
    cell.titleName.text=[titleArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"CelebrationsSegue" sender:nil];
    }
    else if (indexPath.row==1) {
        [self performSegueWithIdentifier:@"LunchSegueIdentfier" sender:nil];
    }
    else if (indexPath.row==2) {
        [self performSegueWithIdentifier:@"ArabianSegueIdentfier" sender:nil];
    }
    else if (indexPath.row==3) {
        [self performSegueWithIdentifier:@"SunshineVCSegueIdentfier" sender:nil];
    }
    else if (indexPath.row==4) {
        [self performSegueWithIdentifier:@"VowsOfEternitySegueIdentfier" sender:nil];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if([segue.identifier isEqualToString:@"CelebrationsSegue"])
    {
        ViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        [self.revealViewController setFrontViewController:rootViewController];
        
    }
    else if([segue.identifier isEqualToString:@"LunchSegueIdentfier"])
    {
        LunchViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LunchViewController"];
        
        [self.revealViewController setFrontViewController:rootViewController];

    }
    else if([segue.identifier isEqualToString:@"ArabianSegueIdentfier"]){
        ArabianNightsVC *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArabianNightsVC"];
        [self.revealViewController setFrontViewController:rootViewController];
    }
    else if([segue.identifier isEqualToString:@"SunshineVCSegueIdentfier"]){
        SunshineVC *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SunshineVC"];
        [self.revealViewController setFrontViewController:rootViewController];
    }
    else if([segue.identifier isEqualToString:@"VowsOfEternitySegueIdentfier"]){
        VowsOfEternity *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"VowsOfEternity"];
        [self.revealViewController setFrontViewController:rootViewController];
    }


    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
