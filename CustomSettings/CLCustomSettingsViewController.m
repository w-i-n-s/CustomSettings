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

@end

@implementation CLCustomSettingsViewController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
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
	
    NSString *path = [self getSettingFileAtBundle:@"Settings.bundle" withFile:self.fileName];
    NSLog(@"path: %@",path);
    
    NSDictionary *settingsBundle = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //NSLog(@"%@",settingsBundle);
    
    //#define kIASKPSGroupSpecifier                 @"PSGroupSpecifier"
    //#define kIASKPSToggleSwitchSpecifier          @"PSToggleSwitchSpecifier"
    //#define kIASKPSMultiValueSpecifier            @"PSMultiValueSpecifier"
    //#define kIASKPSSliderSpecifier                @"PSSliderSpecifier"
    //#define kIASKPSTitleValueSpecifier            @"PSTitleValueSpecifier"
    //#define kIASKPSTextFieldSpecifier             @"PSTextFieldSpecifier"
    //#define kIASKPSChildPaneSpecifier             @"PSChildPaneSpecifier"
    
    NSInteger numberOfSection = -1;
    NSArray *preferenceSpecifiers	= [settingsBundle objectForKey:@"PreferenceSpecifiers"];
	dataSource = [[NSMutableArray alloc] init];
	
	for (NSDictionary *specifier in preferenceSpecifiers) {
        //NSLog(@"specifier %@",specifier);
        
        
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
    NSLog(@"dataSource %d",[dataSource count]);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    NSLog(@"item: %@",item);
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
        NSLog(@"PSToggleSwitchSpecifier");
        //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UISwitch *toggleButton = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        toggleButton.on = (BOOL)[item objectForKey:@"DefaultValue"];
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
        NSLog(@"custom button");
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1];
    NSLog(@"item: %@",item);
    
    NSString *type = [item objectForKey:@"Type"];
    NSLog(@"type: %@",type);
    NSString *defaultValue = [NSString stringWithFormat:@"%@",[item objectForKey:@"DefaultValue"]];
    NSLog(@"defaultValue: %@",defaultValue);
    
    if ([type isEqualToString:@"PSMultiValueSpecifier"]==YES) {
        NSLog(@"PSMultiValueSpecifier selected");
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
        NSLog(@"fileName %@",fileName);
        CLCustomSettingsViewController *csSettingsViewController = [[CLCustomSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        csSettingsViewController.fileName = fileName;
        csSettingsViewController.title = [item objectForKey:@"Title"];
        [self.navigationController pushViewController:csSettingsViewController animated:YES];
    }
}

- (void)selectedViewController:(CLMultiValueSpecifierViewController *)viewController atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"key %@",viewController.key);
    NSLog(@"%@",indexPath);
    NSDictionary *item = (NSDictionary *)[[dataSource objectAtIndex:viewController.parentIndexPath.section] objectAtIndex:viewController.parentIndexPath.row+1];
    NSString *title = [viewController.titles objectAtIndex:indexPath.row];
    NSString *value = [viewController.values objectAtIndex:indexPath.row];
    [item setValue:value forKey:@"DefaultValue"];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:viewController.parentIndexPath];
    cell.detailTextLabel.text = title;
}
@end
