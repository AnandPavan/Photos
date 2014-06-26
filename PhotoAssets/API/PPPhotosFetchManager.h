//
//  PPPhotosFetchManager.h
//  PhotoAssets
//
//  Created by Anand on 6/25/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPhotoMetaData.h"

@interface PPPhotosFetchManager : NSObject

+ (PPPhotosFetchManager *) defaultManager;

- (void) fetchNumberOfPhotosUsingBlock:(void (^)(NSArray *array, NSError *error))block;
- (void) fetchPhotoThumbNailImageWithIndex:(NSInteger)index usingBlock:(void(^)(UIImage *thumbNailImage,NSInteger row, NSError *error))block;
- (void) fetchFullscreenImageWithIndex:(NSInteger)index usingBlock:(void(^)(UIImage *thumbNailImage, NSError *error))block;
@end
