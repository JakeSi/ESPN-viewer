//
//  TableViewController.h
//  BootCamp
//
//  Created by DX109-XL on 4/28/2014.
//  Copyright (c) 2014 pivotallabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDataSource>
@property (assign, nonatomic) BOOL ascending;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end

NSString* webpageUrl;
NSInteger* rowSelected;
NSMutableArray *urlArray;
NSMutableArray *imagesArray;