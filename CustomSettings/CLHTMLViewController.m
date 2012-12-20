//
//  CLHTMLViewController.m
//  CustomSettings
//
//  Created by Darcy Liu on 12/21/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import "CLHTMLViewController.h"

@interface CLHTMLViewController (){
    UIWebView *myWebView;
}

@end

@implementation CLHTMLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    myWebView.scalesPageToFit = NO;
    
    [self.view addSubview:myWebView];
    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:self.fileName withExtension:@"html"];
    [myWebView loadRequest:[NSURLRequest requestWithURL:infoFileURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
