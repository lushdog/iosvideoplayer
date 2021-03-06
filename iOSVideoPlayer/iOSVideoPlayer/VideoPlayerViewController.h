//
//  VideoPlayerViewController.h
//  iOSVideoPlayer
//
//  Created by Matthew Moore on 11-07-21.
//  Copyright 2011 Matt Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "RootViewController.h"

@interface VideoPlayerViewController : UIViewController

@property (nonatomic, strong) Video* video;
@property (nonatomic, strong) RootViewController* rootViewController;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* summaryLabel;
@property (nonatomic, strong) IBOutlet UIWebView *videoWebView;

- (id)initWithVideo: (Video*)video;
- (void)embedYouTube:(NSString*)youtubeId;
- (IBAction)closePlayer:(id)sender;

@end
