//
//  TimeViewController.h
//  iOSVideoPlayer
//
//  Created by Matt Moore on 11-10-22.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeView.h"
#import "TimeScrollView.h"

@interface TimeViewController : UIViewController <TimeViewDelegate>
{}

//TODO: help screen content
//TODO: add new level of detail whereby the play button isn't shown until max

@property (strong, nonatomic) IBOutlet TimeScrollView *timeScrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;

-(IBAction)showHelp:(id)sender;


@end
