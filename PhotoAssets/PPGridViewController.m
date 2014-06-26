//
//  PPGridViewController.m
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "PPGridViewController.h"
#import "PPPhotosFetchManager.h"
#import "PPCellView.h"
#import "PPPhotoMetaData.h"
#import "PPDetailViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface PPGridViewController ()

@property(nonatomic,strong)NSMutableArray      *imagesArray;

-(void)getImagesFromPhotos;
-(void)loadImagesVisibleCells;
-(UIImage *)getFullImage:(NSInteger)selectedImage;
-(void)photoFetchFailed:(NSString *)message;

@end

NSString *kCellID = @"ppCellID";

@implementation PPGridViewController

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
    self.imagesArray  = [[NSMutableArray alloc]init];
    
    if([self.typeOfSelection isEqualToString:@"Photos"]){
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getImagesFromPhotos];
        });
        
    }else if([self.typeOfSelection isEqualToString:@"Flicker"]){
        
    }else{
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    
    return [self.imagesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"cellForItemAtIndexPath = %d and %d",indexPath.item,indexPath.row);
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    PPCellView *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    PPPhotoMetaData  *metaData = [self.imagesArray objectAtIndex:indexPath.item];
    if([self.typeOfSelection isEqualToString:@"Photos"]){
    
        if(!metaData.thumbnailImage){
            cell.cellImage.image = [UIImage imageNamed:@"Default.png"];
            [self loadImagesVisibleCells];
        }
        else{
            //NSLog(@"Load Image");
            cell.cellImage.image = metaData.thumbnailImage;
            
        }
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PPDetailViewController *pdc = [self.storyboard instantiateViewControllerWithIdentifier:@"PPDetailViewController"];
    pdc.image = [self getFullImage:indexPath.row];
    [self.navigationController pushViewController:pdc animated:YES];
   
}

-(UIImage *)getFullImage:(NSInteger)selectedImage{
    
    __block  UIImage *fullImage = nil;
    
    PPPhotosFetchManager  *photFetcher = [PPPhotosFetchManager defaultManager];
    [photFetcher fetchFullscreenImageWithIndex:selectedImage usingBlock:^(UIImage *fullscreenImage,NSError *error){
        fullImage    = fullscreenImage;
    }];
    return fullImage;
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getImagesFromPhotos{
    
    PPPhotosFetchManager  *photFetcher = [PPPhotosFetchManager defaultManager];
    [photFetcher fetchNumberOfPhotosUsingBlock:^(NSArray *array,NSError *error){
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has not allowed to acees it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        if(errorMessage && [error code] < 0 ){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self photoFetchFailed:errorMessage];
            });
        }
        else{
            [self.imagesArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"Count = %d",[self.imagesArray count]);
                if([self.imagesArray count] == 0){
                  [self photoFetchFailed:@"No Photos"];
                }
                else{
                  [self.collectionView reloadData];
                }
            });
        }
    }];
}

-(void)photoFetchFailed:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    
    [alertView show];
}
- (void)loadImagesVisibleCells{
    // NSLog(@"loadImagesVisibleCells");
    if ([self.imagesArray count] > 0 )
    {
    // NSArray *visiblePaths = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            __block  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            //NSLog(@"%ld",(long)indexPath.row);
            
            PPPhotoMetaData  *metaData =  [self.imagesArray objectAtIndex:indexPath.row];
            if(!metaData.thumbnailImage){
                
                PPPhotosFetchManager  *photFetcher = [PPPhotosFetchManager defaultManager];
                [photFetcher fetchPhotoThumbNailImageWithIndex:indexPath.row usingBlock:^(UIImage *thumbNailImage,NSInteger row,NSError *error){
                    PPPhotoMetaData  *metaData =  [self.imagesArray objectAtIndex:row];
                    metaData.thumbnailImage    = thumbNailImage;
                    //NSLog(@"Photo Fetched completed");
                    
                }];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
        [self loadImagesVisibleCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self loadImagesVisibleCells];
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
