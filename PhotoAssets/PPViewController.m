//
//  PPViewController.m
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "PPViewController.h"
#import "PPGridViewController.h"


@interface PPViewController ()

@property (nonatomic, strong) NSMutableArray  *photoTypesArray;

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     //self.photoTypesArray= @[@"Photos", @"Flicker", @"Picasso"];
    self.photoTypesArray = [[NSMutableArray alloc]initWithObjects:@"Photos", @"Flicker", @"Picasso", nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  
}

#pragma mark - UITableViewDataSource

// determine the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self.photoTypesArray count];
}

// determine the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [self.photoTypesArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPGridViewController *pgc = [self.storyboard instantiateViewControllerWithIdentifier:@"PPGridViewController"];
    pgc.typeOfSelection = [self.photoTypesArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pgc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
