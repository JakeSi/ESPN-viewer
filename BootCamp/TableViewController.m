//
//  TableViewController.m
//  BootCamp
//
//  Created by DX109-XL on 4/28/2014.
//  Copyright (c) 2014 pivotallabs. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SidebarViewController.h"



@interface TableViewController ()
@property (strong, nonatomic) NSArray *googlePlacesArrayFromAFNetworking;

@end


@implementation TableViewController

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
    [self makeRestaurantRequests];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    urlArray = [[NSMutableArray alloc]init];
    imagesArray = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // Change button color
   _sidebarButton.tintColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AFNetworking 

-(void)makeRestaurantRequests
{
    NSURL *url = [NSURL URLWithString:@"http://skoushan.com/articles.json"];
    if (pickedURL != nil) {
        url = [NSURL URLWithString:pickedURL];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"headlines"];
//        NSArray *keys = {@"headline0", @"headline1", @"headline2", @"headline3", @"headline4", @"headline5", @"headline6", @"headline7", @"headline8", @"headline9"};

       // NSLog(@"%@", self.googlePlacesArrayFromAFNetworking);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
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
    return [self.googlePlacesArrayFromAFNetworking count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
   
    
    
    //NSLog(self.googlePlacesArrayFromAFNetworking[0]);'
    UIFont *myFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
        
        myFont = [UIFont boldSystemFontOfSize: 18.0];
    }
    else
    {
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
         myFont = [UIFont boldSystemFontOfSize: 15.0];
    }
    
    
    
    cell.textLabel.font  = myFont;
    
    
      cell.textLabel.text = [tempDictionary objectForKey: @"headline"];
    
    
//    CALayer *imageLayer = cell.imageView.layer;
//    [imageLayer setCornerRadius:35.5];
//    [imageLayer setBorderWidth:1];
//    [imageLayer setMasksToBounds:YES];
    
    
    
    
    
    NSDictionary *links = [tempDictionary objectForKey:@"links"];
    NSDictionary *mobile = [links objectForKey:@"mobile"];
    webpageUrl = [mobile objectForKey:@"href"];
    
        if ([urlArray count] > indexPath.row) {
    
        }else
        {
            if (webpageUrl != nil) {
                [urlArray insertObject:webpageUrl atIndex:indexPath.row];
            }
            NSArray *level2 = [tempDictionary objectForKey:@"images"];
            NSString *imageURL = @"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ2dLB8V7SudiSRDXhS7L39ek8B1MvVRwesr0nHrDovj8bftQWZdh3xBQwQcQ";
            if([level2 count]>0)
            {
                NSDictionary *level3 = [level2 objectAtIndex:0];
                imageURL = [level3 objectForKey:@"url"];
            }
            
            UIFont *caption = [UIFont fontWithName: @"Helvetica" size: 10.0];
            cell.detailTextLabel.font = caption;
            cell.detailTextLabel.text = [tempDictionary objectForKey:@"description"];
            
            
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            UIImage *croppedImg = nil;
            if (image.size.height > image.size.width) {
                CGRect cropRect = CGRectMake(0,(abs(image.size.width - image.size.height))/2, image.size.width, image.size.width); //set your rect size.
                [imagesArray insertObject:[self croppIngimageByImageName:image toRect:cropRect] atIndex:indexPath.row];
            }else{
                CGRect cropRect = CGRectMake((abs(image.size.width - image.size.height))/2,0, image.size.height, image.size.height); //set your rect size.
                [imagesArray insertObject:[self croppIngimageByImageName:image toRect:cropRect] atIndex:indexPath.row];
            }
        }
    
    cell.imageView.image = [imagesArray objectAtIndex:indexPath.row];
    
    CGSize itemSize = CGSizeMake(cell.frame.size.height-10,cell.frame.size.height -10 );
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //int a = [imagesArray objectAtIndex:indexPath.row].size.height;
//NSLog([NSString stringWithFormat:@"%d", [a]];
    return cell;
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
}


- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}


- (void)changeSorting
{
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}

- (void)updateTable
{
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [self viewDidLoad];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 100;
    }
    
    return 75;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
