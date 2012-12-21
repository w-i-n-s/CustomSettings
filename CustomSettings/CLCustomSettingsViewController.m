//
//  CLCustomSettingsViewController.m
//  CustomSettings
//
//  Created by Darcy Liu on 12/20/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import "CLCustomSettingsViewController.h"

static NSString *kCellIdentifier = @"MyIdentifier";

@interface CLCustomSettingsViewController (){
    NSMutableArray *dataSource;
}
@property (nonatomic,retain) NSUserDefaults *userPrefs;
@end

@implementation CLCustomSettingsViewController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.userPrefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (id)initWithBundle:(NSString *)bundle andFile:(NSString *)fileName{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.userPrefs = [NSUserDefaults standardUserDefaults];
        self.bundle = bundle;
        self.fileName = fileName;
    }
    return self;
}


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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (self.fileName == nil) {
        self.fileName = @"Root";
    }
	
    NSString *path = [self getSettingFileAtBundle:self.bundle withFile:self.fileName];
    
    NSDictionary *settingsBundle = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSInteger numberOfSection = -1;
    NSArray *preferenceSpecifiers	= [settingsBundle objectForKey:@"PreferenceSpecifiers"];
	dataSource = [[NSMutableArray alloc] init];
	
	for (NSDictionary *specifier in preferenceSpecifiers) {
        if ([(NSString*)[specifier objectForKey:@"Type"] isEqualToString:@"PSGroupSpecifier"]) {
            NSMutableArray *groupContainer = [[NSMutableArray alloc] init];
            [groupContainer addObject:specifier];
            [dataSource addObject:groupContainer];
            numberOfSection ++;
        }else{
            if (numberOfSection == -1) {
				NSMutableArray *groupContainer = [[NSMutableArray alloc] init];
				[dataSource addObject:groupContainer];
                numberOfSection++;
			}
            [(NSMutableArray*)[dataSource objectAtIndex:numberOfSection] addObject:specifier];
        }
    }

    //[self regisiterDefaultsChangeEvnet];
//    [[NSUserDefaults standardUserDefaults] addObserver:self
//                                            forKeyPath:@"enabled_preference"
//                                               options:NSKeyValueObservingOptionNew
//                                               context:NULL];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context
{
    if([keyPath isEqual:@"enabled_preference"])
    {
        NSLog(@"SomeKey change: %@", change);
    }
}
- (void)regisiterDefaultsChangeEvnet{
    NSLog(@"+regisiterDefaultsChangeEvnet");
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(defaultsChanged:)  name:NSUserDefaultsDidChangeNotification object:nil];
    NSLog(@"-regisiterDefaultsChangeEvnet");
}

- (void)defaultsChanged:(NSNotification *)notification {
    NSLog(@"+defaultsChanged");
    // Get the user defaults
    NSUserDefaults *defaults = (NSUserDefaults *)[notification object];
    NSLog(@"defaults: %@",defaults);
    NSLog(@"-defaultsChanged");
}

-(NSString *)getSettingFileAtBundle:(NSString *)bundle withFile:(NSString *)fileName{
    if (bundle==nil) {
        bundle = @"Settings.bundle";
    }
    if (fileName==nil) {
        fileName = @"Root";
    }
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[bundle stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[dataSource objectAtIndex:section] count]-1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:section] objectAtIndex:0];
    return [item objectForKey:@"Title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:section] objectAtIndex:0];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:tableView:heightForHeaderForItem:inSection:)]) {
        return [self.delegate settingsViewController:self
                                           tableView:tableView
                              heightForHeaderForItem:item
                                         inSection:section];
    }
    
    return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    NSString *type = [item objectForKey:@"Type"];
    if ([type isEqualToString:@"PSButtonValueSpecifier"]) {
        return tableView.rowHeight - 4;
    }
    return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:section] objectAtIndex:0];
    NSString *key = [item objectForKey:@"Key"];
    
    UIView *view = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:tableView:viewForHeaderForKey:)]) {
        view = [self.delegate settingsViewController:self tableView:tableView viewForHeaderForKey:key];
    }
    
    return view;
};

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:section] objectAtIndex:0];
    NSString *key = [item objectForKey:@"Key"];
    UIView *view = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewController:tableView:viewForFooterForKey:::)]) {
        view = [self.delegate settingsViewController:self tableView:tableView viewForFooterForKey:key];
    }
    
    return view;
};
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];

    NSString *type = [item objectForKey:@"Type"];
    
    cell.textLabel.text = [item objectForKey:@"Title"];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([type isEqualToString:@"PSSliderSpecifier"]==YES) {
        cell.textLabel.text = @"PSSliderSpecifier not supported.";
        //[NSString stringWithFormat:@"%@",[item objectForKey:@"DefaultValue"]];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([type isEqualToString:@"PSMultiValueSpecifier"]==YES) {
        NSString *defaultValue = [NSString stringWithFormat:@"%@",[item objectForKey:@"DefaultValue"]];
        NSArray *titles = [item objectForKey:@"Titles"];
        NSArray *values = [item objectForKey:@"Values"];
        NSString *title;
        int i;
        for (i=0; i<[values count]; i++) {
            NSString *value = [values objectAtIndex:i];
            if ([value isEqual:defaultValue]) {
                break;
            }
        }
        
        if (i<[titles count]) {
            title = [titles objectAtIndex:i];
        }
        
        if (title == nil) {
            title = defaultValue;
        }
        
        cell.detailTextLabel.text = title;
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if ([type isEqualToString:@"PSToggleSwitchSpecifier"]==YES) {
        CLSwitch *toggleButton = [[CLSwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [toggleButton addTarget:self
                         action:@selector(toggleAction:)
               forControlEvents:UIControlEventValueChanged];
        //(BOOL)[item objectForKey:@"DefaultValue"];
        toggleButton.on = [self.userPrefs boolForKey:[item objectForKey:@"Key"]];
        toggleButton.key = [item objectForKey:@"Key"];
        toggleButton.indexPath = indexPath;
        
        cell.accessoryView = toggleButton;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([type isEqualToString:@"PSTitleValueSpecifier"]==YES) {
        cell.detailTextLabel.text = [item objectForKey:@"DefaultValue"];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([type isEqualToString:@"PSButtonValueSpecifier"]) {
        //custom button
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PSButtonValueSpecifier"];
        NSString *custom = [item objectForKey:@"Custom"];
        if ([custom isEqualToString:@"Custom"]) {
            CLButton *customButton = [CLButton buttonWithType:UIButtonTypeCustom];
            customButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            
            if ([item objectForKey:@"bg"]) {
                UIImage *bg = [UIImage imageNamed:[item objectForKey:@"bg"]];
                [customButton setBackgroundImage:[bg stretchableImageWithLeftCapWidth:bg.size.width/2 topCapHeight:bg.size.height/2]  forState:UIControlStateNormal];
            }
            
            if ([item objectForKey:@"bg_highlighted"]) {
                UIImage *bghl = [UIImage imageNamed:[item objectForKey:@"bg_highlighted"]];
                [customButton setBackgroundImage:[bghl stretchableImageWithLeftCapWidth:bghl.size.width/2 topCapHeight:bghl.size.height/2] forState:UIControlStateHighlighted];
            }
            [customButton addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [customButton setTitle:[item objectForKey:@"Title"] forState:UIControlStateNormal];
            customButton.frame = CGRectMake(0, -2 , cell.frame.size.width , cell.frame.size.height);
            
            customButton.key = [item objectForKey:@"Key"];
            customButton.indexPath = indexPath;
            
            cell.textLabel.text = nil;
            [cell addSubview:customButton];
        }
        
        NSNumber *align = [item objectForKey:@"Align"];
        
        
        cell.textLabel.text = [item objectForKey:@"Title"];
        cell.textLabel.textAlignment = [align intValue];
        
        NSNumber *accessoryType = [item objectForKey:@"AccessoryType"];
        cell.accessoryView = nil;
        cell.accessoryType = [accessoryType intValue];//UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if ([type isEqualToString:@"PSHTMLSpecifier"]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

- (void)itemValueChanged:(id)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsItemDidChanged:WithSettingsViewController:tableView:)]) {
        [self.delegate settingsItemDidChanged:item WithSettingsViewController:self tableView:self.tableView];
    }
}

- (void)tapButtonForItem:(id)item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapButtonforItem:WithSettingsViewController:tableView:)]) {
        [self.delegate tapButtonforItem:item WithSettingsViewController:self tableView:self.tableView];
    }
}


- (void)tapButtonAction:(id)sender{
    NSLog(@"tapButton: %@",sender);
    CLButton *btn = (CLButton *)sender;
    
    NSIndexPath *indexPath = btn.indexPath;
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    [self tapButtonForItem:item];
}

#pragma mark - Switch Action
- (void)toggleAction:(id)sender{
    CLSwitch *sw = (CLSwitch *)sender;
    [self.userPrefs setBool:sw.isOn forKey:sw.key];
    [self.userPrefs synchronize];
    
    NSIndexPath *indexPath = sw.indexPath;
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    [item setValue:[NSNumber numberWithBool:sw.isOn]  forKey:@"DefaultValue"];
    
    [self itemValueChanged:item];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    //NSLog(@"item: %@",item);
    
    NSString *type = [item objectForKey:@"Type"];
    //NSLog(@"type: %@",type);
    NSString *defaultValue = [NSString stringWithFormat:@"%@",[item objectForKey:@"DefaultValue"]];
    //NSLog(@"defaultValue: %@",defaultValue);
    
    if ([type isEqualToString:@"PSMultiValueSpecifier"]==YES) {
        NSArray *titles = [item objectForKey:@"Titles"];
        NSArray *values = [item objectForKey:@"Values"];
        
        if ([titles count] == [values count]) {
            NSString *key = [item objectForKey:@"Key"];
            CLMultiValueSpecifierViewController *mvsv = [[CLMultiValueSpecifierViewController alloc] initWithStyle:UITableViewStyleGrouped];
            mvsv.delegate = self;
            mvsv.parentIndexPath = indexPath;
            mvsv.title = [item objectForKey:@"Title"];
            mvsv.titles = titles;
            mvsv.values = values;
            mvsv.defaultValue = defaultValue;
            mvsv.key = key;
            [self.navigationController pushViewController:mvsv animated:YES];
        }
    }
    if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        NSString *fileName = [item objectForKey:@"File"];
        CLCustomSettingsViewController *csSettingsViewController = [[CLCustomSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        csSettingsViewController.delegate = self.delegate;
        csSettingsViewController.fileName = fileName;
        csSettingsViewController.title = [item objectForKey:@"Title"];
        [self.navigationController pushViewController:csSettingsViewController animated:YES];
    }
    
    if ([type isEqualToString:@"PSHTMLSpecifier"]) {
        CLHTMLViewController *htmlViewController = [[CLHTMLViewController alloc] init];
        htmlViewController.title = [item objectForKey:@"Title"];
        [self.navigationController pushViewController:htmlViewController animated:YES];
    }
    
    if ([type isEqualToString:@"PSButtonValueSpecifier"]) {
        [self tapButtonForItem:item];
    }
}

- (void)selectedViewController:(CLMultiValueSpecifierViewController *)viewController atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:viewController.parentIndexPath.section] objectAtIndex:viewController.parentIndexPath.row+1];
    NSString *title = [viewController.titles objectAtIndex:indexPath.row];
    NSString *value = [viewController.values objectAtIndex:indexPath.row];
    [item setValue:value forKey:@"DefaultValue"];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:viewController.parentIndexPath];
    cell.detailTextLabel.text = title;
    
    [self itemValueChanged:item];
}
@end
