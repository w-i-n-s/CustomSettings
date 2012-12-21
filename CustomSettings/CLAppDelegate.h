//
//  CLAppDelegate.h
//  CustomSettings
//
//  Created by Darcy Liu on 12/20/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCustomSettingsViewController.h"
@interface CLAppDelegate : UIResponder <UIApplicationDelegate,CLCustomSettingsViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
