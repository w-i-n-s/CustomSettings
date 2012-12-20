//
//  CLMultiValueSpecifierViewController.h
//  CustomSettings
//
//  Created by Darcy Liu on 12/21/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLMultiValueSpecifierViewDelegate;

@interface CLMultiValueSpecifierViewController : UITableViewController
@property (nonatomic,retain) NSArray *titles;
@property (nonatomic,retain) NSArray *values;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) NSString *defaultValue;
@property (nonatomic,retain) NSIndexPath *parentIndexPath;
@property (nonatomic,retain) NSIndexPath *selectedIndexPath;
@property (nonatomic,retain) id<CLMultiValueSpecifierViewDelegate> delegate;
@end

@protocol CLMultiValueSpecifierViewDelegate <NSObject>

- (void)selectedViewController:(CLMultiValueSpecifierViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;

@end
