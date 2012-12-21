//
//  CLAppDelegate.m
//  CustomSettings
//
//  Created by Darcy Liu on 12/20/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import "CLAppDelegate.h"

@implementation CLAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    CLCustomSettingsViewController *settingViewController = [[CLCustomSettingsViewController alloc] init];
    settingViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)tapButtonforItem:(id)item WithSettingsViewController:(CLCustomSettingsViewController *)settingsViewContoller tableView:(UITableView *)tableView{
    NSLog(@"tapButtonforItem: %@",item);
}

- (void)settingsItemDidChanged:(id)item
    WithSettingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                     tableView:(UITableView *)tableView{
    NSLog(@"item %@",item);
}
- (UIView *)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller tableView:(UITableView *)tableView viewForHeaderForKey:(NSString *)key{
    if (key!=nil && [key isEqualToString:@"section_about"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
        //view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.jpg"]];
        //imageView.frame = view.frame;
        CGFloat left = (view.frame.size.width - imageView.frame.size.width)/2;
        CGFloat height = (view.frame.size.height - imageView.frame.size.height)/2;
        imageView.frame  = CGRectMake(left, height, imageView.frame.size.width, imageView.frame.size.height);
        [view addSubview:imageView];
        return view;
    }
    return nil;
}

- (CGFloat)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                        tableView:(UITableView *)tableView
           heightForHeaderForItem:(id)item inSection:(NSInteger)section{
    NSDictionary *obj = (NSDictionary *)item;
    NSString *key = [obj objectForKey:@"Key"];
    NSString *title = [obj objectForKey:@"Title"];
    if (key!=nil && [key isEqualToString:@"section_about"]) {
        return 200;
    }

    if (title !=nil && ![title isEqualToString:@""]) {
        return 22;
    }
    return tableView.sectionHeaderHeight;
}

- (CGFloat)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller tableView:(UITableView *)tableView heightForFooterForItem:(id)item inSection:(NSInteger)section{
    NSDictionary *obj = (NSDictionary *)item;
    //NSString *key = [obj objectForKey:@"Key"];
    NSString *title = [obj objectForKey:@"Title"];
    if (title !=nil) {
        return 22;
    }
    return tableView.sectionFooterHeight;
}

- (UIView *)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller tableView:(UITableView *)tableView viewForFooterForKey:(NSString *)key{
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
