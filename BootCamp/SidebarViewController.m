//
//  SidebarViewController.m
//  BootCamp
//
//  Created by DX109-XL on 5/1/2014.
//  Copyright (c) 2014 pivotallabs. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"

@interface SidebarViewController ()
@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SidebarViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    _menuItems = @[@"Headlines", @"NBA", @"NFL", @"MLB", @"Soccer"];
    iconArray = [[NSArray alloc] initWithObjects:@"HeadlinesIcon.png", @"NBAIcon.png", @"NFLIcon.png", @"MLBIcon.png", @"SoccerIcon.png", nil];
    cellSelected = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (indexPath.row == 0)
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:cellSelected];
    oldCell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    
    cellSelected = indexPath;
    
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [_menuItems objectAtIndex:indexPath.row];
    
        
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"Headlines"]) {
        pickedURL = @"http://api.espn.com/v1/sports/news/headlines/top?apikey=8pa4vr4uquavzwq2ffm7w5cx";
    }else if ([segue.identifier isEqualToString:@"NBA"]){
        pickedURL = @"http://api.espn.com/v1/sports/basketball/nba/news/headlines?apikey=8pa4vr4uquavzwq2ffm7w5cx";
    }else if ([segue.identifier isEqualToString:@"NFL"]){
        pickedURL = @"http://api.espn.com/v1/sports/football/nfl/news/headlines?apikey=8pa4vr4uquavzwq2ffm7w5cx";
    }else if ([segue.identifier isEqualToString:@"MLB"]){
        pickedURL = @"http://api.espn.com/v1/sports/baseball/mlb/news/headlines?apikey=8pa4vr4uquavzwq2ffm7w5cx";
    }else if ([segue.identifier isEqualToString:@"Soccer"]){
        pickedURL = @"http://api.espn.com/v1/sports/soccer/eng.1/news/headlines?apikey=8pa4vr4uquavzwq2ffm7w5cx";
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
