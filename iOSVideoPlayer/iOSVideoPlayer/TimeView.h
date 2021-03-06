//
//  TimeView.h
//  iOSVideoPlayer
//
//  Created by Matt Moore on 11-10-22.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol TimeViewDelegate <NSObject>

-(void)showVideoWithYoutubeId:(NSString*)youtubeId;

@end



@interface TimeView : UIView <UIGestureRecognizerDelegate>
{
    
}
@property (nonatomic, assign) int maxDetailLevel;
@property (nonatomic, assign) int currentDetailLevel;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, assign) id <TimeViewDelegate> delegate;  
@property (nonatomic, strong) NSString *title;

- (void) initGestureRecognizers;
- (void)handleOneFingerTap:(UITapGestureRecognizer *)sender;
- (void)handleTwoFingerTap:(UITapGestureRecognizer *)sender;
- (void)updateCurrentDetailLevel:(int)newDetailLevel;

@end
