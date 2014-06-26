//
//  PPDetailViewController.m
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "PPDetailViewController.h"

@interface PPDetailViewController ()

@end

@implementation PPDetailViewController

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
    
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 320)];
    myImage.contentMode  = UIViewContentModeScaleAspectFit;
    myImage.image = self.image;
    
    [self.view addSubview:myImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
