//
//  CLCustomSettingsViewController.h
//  CustomSettings
//
//  Created by Darcy Liu on 12/20/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMultiValueSpecifierViewController.h"
#import "CLHTMLViewController.h"
#import "CLSwitch.h"
#import "CLButton.h"

@protocol CLCustomSettingsViewControllerDelegate;
@interface CLCustomSettingsViewController : UITableViewController<CLMultiValueSpecifierViewDelegate>
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) id<CLCustomSettingsViewControllerDelegate> delegate;
@end

@protocol CLCustomSettingsViewControllerDelegate <NSObject>

- (void)settingsItemDidChanged:(id)item
    WithSettingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                     tableView:(UITableView *)tableView;

- (void)tapButtonforItem:(id)item
WithSettingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
               tableView:(UITableView *)tableView;

- (CGFloat)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                        tableView:(UITableView *)tableView
           heightForHeaderForItem:(id)item
                        inSection:(NSInteger)section;

- (CGFloat)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                        tableView:(UITableView *)tableView
           heightForFooterForItem:(id)item
                        inSection:(NSInteger)section;

- (UIView *)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                         tableView:(UITableView *)tableView
           viewForHeaderForKey:(NSString *)key;

- (UIView *)settingsViewController:(CLCustomSettingsViewController *)settingsViewContoller
                         tableView:(UITableView *)tableView
           viewForFooterForKey:(NSString *)key;

@end
