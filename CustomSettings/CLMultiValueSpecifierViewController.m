//
//  CLMultiValueSpecifierViewController.m
//  CustomSettings
//
//  Created by Darcy Liu on 12/21/12.
//  Copyright (c) 2012 Darcy Liu. All rights reserved.
//

#import "CLMultiValueSpecifierViewController.h"

@interface CLMultiValueSpecifierViewController ()
    
@end

@implementation CLMultiValueSpecifierViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"CLMultiValueSpecifierViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
	}
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.titles objectAtIndex:indexPath.row]];
    NSString *value = (NSString *)[self.values objectAtIndex:indexPath.row];
    if ([self.defaultValue isEqual:value]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedIndexPath != nil) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath;
    
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(selectedViewController:atIndexPath:)]) {
        [self.delegate selectedViewController:self atIndexPath:indexPath];
    }
}

@end
