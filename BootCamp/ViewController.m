//
//  ViewController.m
//  BootCamp
//
//  Created by DX109-XL on 4/28/2014.
//  Copyright (c) 2014 pivotallabs. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([urlArray count] != 0) {
        NSString *fullURL = [urlArray objectAtIndex:rowSelected];
        
        NSLog([NSString stringWithFormat: @"%d", (int)rowSelected]);
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_viewWeb loadRequest:requestObj];
         _viewWeb.frame = [[UIScreen mainScreen] bounds];

    }else{
        NSLog(@"Error: no URL");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _viewWeb.frame = [[UIScreen mainScreen] bounds];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _viewWeb.frame = [[UIScreen mainScreen] bounds];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _viewWeb.frame = [[UIScreen mainScreen] bounds];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _viewWeb.frame = [[UIScreen mainScreen] bounds];
}


@end
