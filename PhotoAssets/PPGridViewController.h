//
//  PPGridViewController.h
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPGridViewController : UIViewController


@property(nonatomic,  weak)IBOutlet UICollectionView    *collectionView;
@property(nonatomic,strong)NSString                     *typeOfSelection;


@end
