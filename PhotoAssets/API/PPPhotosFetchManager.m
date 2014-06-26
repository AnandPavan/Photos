//
//  PPPhotosFetchManager.m
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "PPPhotosFetchManager.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsFilter.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface PPPhotosFetchManager()
@property (nonatomic, strong) ALAssetsLibrary   *assetsLibrary;
@property (nonatomic, strong) NSMutableArray    *devicePhotosArray;
@end

@implementation PPPhotosFetchManager

static PPPhotosFetchManager *_defaultManager = nil;

+ (PPPhotosFetchManager *) defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[PPPhotosFetchManager allocWithZone:NULL] init];
    });
    return _defaultManager;
}

-(id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void) fetchNumberOfPhotosUsingBlock:(void (^)(NSArray *array, NSError *error))block{
    __block NSMutableArray  *numberOfPhotosArray = [[NSMutableArray alloc]init];
    NSError *error = nil;
    
            if (self.assetsLibrary == nil) {
                self.assetsLibrary = [[ALAssetsLibrary alloc] init];
            }
            if (self.devicePhotosArray == nil) {
                self.devicePhotosArray = [[NSMutableArray alloc] init];
            } else {
                [self.devicePhotosArray removeAllObjects];
            }
            
            // setup our failure view controller in case enumerateGroupsWithTypes fails
            ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
                block(numberOfPhotosArray,error);
            };
            
            // emumerate through our groups and only add groups that contain photos
            ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
                
                ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
                
                [group setAssetsFilter:onlyPhotosFilter];
                
                if ([group numberOfAssets] > 0)
                {
                    [self.devicePhotosArray addObject:group];
                    for(int i=0;i<[group numberOfAssets];i++){
                        PPPhotoMetaData *metaData = [[PPPhotoMetaData alloc]init];
                        [numberOfPhotosArray addObject:metaData];
                    }
                    
                }
                else{
                    //need to give back to the result
                    block(numberOfPhotosArray,error);

                }
            };
     NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];

}
- (void) fetchPhotoThumbNailImageWithIndex:(NSInteger)index usingBlock:(void(^)(UIImage *thumbNailImage,NSInteger row, NSError *error))block{
    __block UIImage *lthumbNailImage = nil;
    __block NSInteger previousGroupCount= 0;
    NSInteger lindex = 0;
    for (lindex = 0; lindex< [self.devicePhotosArray count];lindex++) {
        ALAssetsGroup *group = [self.devicePhotosArray objectAtIndex:lindex ];
        if(previousGroupCount+[group numberOfAssets] >=index)
        {
            break;
        }
        previousGroupCount = previousGroupCount+[group numberOfAssets];
    }
    NSError *error = nil;
    if(self.devicePhotosArray != nil && (lindex < [self.devicePhotosArray count]) ){
        ALAssetsGroup *group =  [self.devicePhotosArray objectAtIndex:lindex];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result && index+previousGroupCount == index){
                CGImageRef thumbnailImageRef = [result thumbnail];
                lthumbNailImage = [UIImage imageWithCGImage:thumbnailImageRef];
                block(lthumbNailImage,index,error);
               
            }
        };
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        
    }
}
- (void) fetchFullscreenImageWithIndex:(NSInteger)index usingBlock:(void(^)(UIImage *fullscreenImage, NSError *error))block{
    
    __block UIImage *lfullscreenImage = nil;
    __block NSInteger previousGroupCount= 0;
    NSInteger lindex = 0;
    for (lindex = 0; lindex< [self.devicePhotosArray count];lindex++) {
        ALAssetsGroup *group = [self.devicePhotosArray objectAtIndex:lindex ];
        if(previousGroupCount+[group numberOfAssets] >=index)
        {
            break;
        }
        previousGroupCount = previousGroupCount+[group numberOfAssets];
    }
    NSError *error = nil;
    if(self.devicePhotosArray != nil && (lindex < [self.devicePhotosArray count]) ){
        ALAssetsGroup *group =  [self.devicePhotosArray objectAtIndex:lindex];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger groupindex, BOOL *stop) {
            if(result && index+previousGroupCount == groupindex){
                ALAssetRepresentation *defaultRep = [result defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
                
                lfullscreenImage = image;
                
                block(lfullscreenImage,error);
                *stop = TRUE;
            }
        };
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        
    }
}

@end
