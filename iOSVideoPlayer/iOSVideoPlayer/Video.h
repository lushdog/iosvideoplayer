//
//  Video.h
//  iOSVideoPlayer
//
//  Created by Matthew Moore on 11-10-02.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Categories;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSNumber * IsNew;
@property (nonatomic, retain) NSNumber * IsQueued;
@property (nonatomic, retain) NSNumber * IsWatched;
@property (nonatomic, retain) NSString * PublicID;
@property (nonatomic, retain) NSString * Summary;
@property (nonatomic, retain) NSString * ThumbnailURL;
@property (nonatomic, retain) NSString * Title;

@end
