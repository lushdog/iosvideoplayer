//
//  HelpViewController.m
//  iOSVideoPlayer
//
//  Created by Matt Moore on 11-12-11.
//  Copyright (c) 2011 Matt Moore. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController

@synthesize doneButton, toolBar;

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
    
    self.toolBar.barStyle = UIBarStyleBlack;
    self.toolBar.translucent = YES;
    self.doneButton.style = UIBarButtonItemStyleDone;
}

-(IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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


@end
