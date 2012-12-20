//
//  CLCustomSettingsViewController.h
//  CustomSettings
//
//  Created by Darcy Liu on 12/20/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMultiValueSpecifierViewController.h"

@interface CLCustomSettingsViewController : UITableViewController<CLMultiValueSpecifierViewDelegate>
@property (nonatomic,retain) NSString *fileName;
@end
