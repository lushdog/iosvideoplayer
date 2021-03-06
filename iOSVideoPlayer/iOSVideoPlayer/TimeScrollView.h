//
//  TimeScrollView.h
//  iOSVideoPlayer
//
//  Created by Matt Moore on 11-10-23.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeView.h"

@interface TimeScrollView : UIScrollView <UIScrollViewDelegate>
{
    TimeView *timeView;
}

@property (nonatomic, assign) float detailZoomStep;
@property (nonatomic, assign) CGPoint centerPreRotate;
@property (nonatomic, strong) UIView *titleView;


- (void)setTimeView:(TimeView*)theTimeView forOrientation:(UIInterfaceOrientation)orientation;
- (void)handleRotation:(UIInterfaceOrientation)orientation;
- (void)setZoomExtentsForOrientation:(UIInterfaceOrientation)orientation;
- (void)updateCurrentDetailLevel;


@end
