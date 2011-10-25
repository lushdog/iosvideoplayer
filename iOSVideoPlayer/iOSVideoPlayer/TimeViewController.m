//
//  TimeViewController.m
//  iOSVideoPlayer
//
//  Created by Matt Moore on 11-10-22.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import "TimeViewController.h"
#import "TimeView.h"

@implementation TimeViewController

@synthesize timeScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //TODO: load scroll dynamically rather than from TimeViewController.xib
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil];
    TimeView *timeView;
    for (id object in bundle)
    {
        if ([object isKindOfClass:[TimeView class]])
            timeView = (TimeView*)object;
    }
    [timeScrollView setTimeView:timeView];
    timeScrollView.delegate = timeScrollView;
    timeScrollView.contentSize = timeView.frame.size;
    timeScrollView.scrollEnabled = YES;
    timeScrollView.bouncesZoom = YES;
    
    //max zoom in is show full node
    CGSize nodeSize = CGSizeMake(300,300);  
    float factor = timeScrollView.frame.size.width / nodeSize.width;
    timeScrollView.maximumZoomScale = factor;
    
    //max zoom out is show full view
    factor = timeScrollView.frame.size.width / timeView.frame.size.width;
    timeScrollView.minimumZoomScale = factor;
    timeScrollView.zoomScale = factor;
    
    timeScrollView.currentDetailLevel = 0;
    timeScrollView.maxDetailLevel = 3;
    timeScrollView.detailZoomStep = (timeScrollView.maximumZoomScale - timeScrollView.minimumZoomScale)  / (timeScrollView.maxDetailLevel);
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


// Notifies when rotation begins, reaches halfway point and ends.
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //TODO: factor out to a 'reset' type of method if needed
    timeScrollView.contentSize = [timeScrollView timeView].frame.size;
}

@end