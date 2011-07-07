//
//  RootViewController.m
//  iOSVideoPlayer
//
//  Created by Matthew Moore on 11-06-22.
//  Copyright 2011 Matt Moore. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Video.h"
#import "VideoCategory.h"
#import "VideoPageViewController.h"
#import "CategoryViewController.h"

#define kNumberOfVideosPerPage 1
#define kNumberOfTestCategories 3

@implementation RootViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize masterScrollView = __masterScrollView;
@synthesize detailScrollView = __detailScrollView;
@synthesize masterViewControllers = __masterViewControllers;
@synthesize detailViewControllers = __detailViewControllers;
@synthesize masterPageControl = __masterPageControl;
@synthesize detailPageControl = __detailPageControl;
@synthesize masterPageControlView = __masterPageControlView;
@synthesize detailPageControlView = __detailPageControlView;
@synthesize categories = __categories;
@synthesize videos = __videos;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    //TODO: save data model
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //setup core data
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    //TODO: load old videos from store
    //          get updated list from network
    //              compare two lists, add (set isNew) and remove as necessary, update exisiting (keep isRead)
    //do fetch requests to get all categories and put in categories array
    //do fetch request for all videos in each category and put in each index of videos array
    //NSArray *savedVideos = [self loadVideoEntities];
    [self loadTestData];
    
    //setup master scroll view, content fully preloaded as master view pages are not complex
    numMasterPages = self.categories.count;
    currentMasterPageNum = 0;
    self.masterPageControl.numberOfPages = numMasterPages;
    self.masterPageControl.currentPage = 0;
    self.masterViewControllers = [self loadMasterViewControllers];  
    self.masterScrollView.contentSize = CGSizeMake(numMasterPages * self.masterScrollView.frame.size.width, self.masterScrollView.frame.size.height);
    self.masterScrollView.scrollsToTop = NO;
    
    for (int i = 0; i < numMasterPages; i++) {
        
        CGRect frame = self.masterScrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        CategoryViewController *categoryViewController = [self.masterViewControllers objectAtIndex:i];
        categoryViewController.currentCategoryLabel.text = @"Foo";
        categoryViewController.nextCategoryLabel.text = @"Foo";
        categoryViewController.previousCategoryLabel.text = @"Foo";
        categoryViewController.view.frame = frame;
        [self.masterScrollView addSubview:categoryViewController.view];
    }

    //setup detail scroll view, lazy loading after each page turn
    self.detailViewControllers = [[NSMutableArray alloc] init];
    numDetailPages = ceil((float)[[self.videos objectAtIndex:0] count] / (float)kNumberOfVideosPerPage);
    self.detailScrollView.scrollsToTop = NO; 
    [self resetDetailScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - Orientation Handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - Scroll View Handling

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.masterScrollView.frame.size.width;
    int pageNum = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if ([sender isEqual:self.masterScrollView])
    {
        currentMasterPageNum = pageNum;
        self.masterPageControl.currentPage = pageNum;
        numDetailPages = ceil((float)[[self.videos objectAtIndex:pageNum] count] / (float)kNumberOfVideosPerPage);
        [self resetDetailScrollView];  
    }
    else 
    {
        currentDetailPageNum = pageNum;
        self.detailPageControl.currentPage = pageNum;
        [self loadDetailPageNumber:pageNum+1];
    }
}

//init categories and then call this to load categories into master view controllers
- (NSMutableArray *)loadMasterViewControllers {
    
    NSMutableArray *categoryViewControllers = [[NSMutableArray alloc] init];
    
    for (int i=0; i < self.categories.count ; i++) 
    {
        
        VideoCategory *category = (VideoCategory*)[self.categories objectAtIndex:i];
        NSString *currentLabel = category.Name;
        
        NSString *previousLabel = nil;
        if (i > 0) 
        {
            VideoCategory *previousCategory = [self.categories objectAtIndex:i - 1];
            previousLabel = previousCategory.Name;
        }        
        
        NSString *nextLabel = nil;
        if (i < self.categories.count - 1)
        {
            VideoCategory *nextCategory = [self.categories objectAtIndex:i + 1];
            nextLabel = nextCategory.Name;
        }
        
        CategoryViewController *categoryViewController = [[CategoryViewController alloc] initWithCategory:currentLabel nextCategory:nextLabel previousCategory:previousLabel];
        [categoryViewControllers addObject:categoryViewController];
    }
    
    return categoryViewControllers;
}


//set currentMasterPageNum and numDetailPages first and then call this to reset detail scroll view
- (void)resetDetailScrollView
{
    self.detailViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < numDetailPages; i++) {
        [self.detailViewControllers addObject:[NSNull null]];
    }
    
    self.detailScrollView.contentSize = CGSizeMake(numDetailPages * self.detailScrollView.frame.size.width, self.detailScrollView.frame.size.height);
    self.detailScrollView.contentOffset = CGPointMake(0,0);
    
    self.detailPageControl.numberOfPages = numDetailPages;
    currentDetailPageNum = 0;
    self.detailPageControl.currentPage = 0;
    
    [self loadDetailPageNumber:0];
    [self loadDetailPageNumber:1];
}


//set currentMasterPageNum and numDetailPages first and then call this to load a detail page
-(void)loadDetailPageNumber:(int)detailPageNum 
{
    if (detailPageNum < 0)
        return;
    if (detailPageNum >= numDetailPages)
        return;
    
    VideoPageViewController *videoPage = [self.detailViewControllers objectAtIndex:detailPageNum];
    if ((NSNull *)videoPage == [NSNull null])
    {
        NSArray *videosForCurrentMasterPage = [self.videos objectAtIndex:currentMasterPageNum];
        int numVideosForCurrentMasterPage = [videosForCurrentMasterPage count];
        
        NSInteger lengthOfRange = MIN(kNumberOfVideosPerPage, numVideosForCurrentMasterPage - (detailPageNum * kNumberOfVideosPerPage));
        NSRange rangeOfVideos = NSMakeRange(detailPageNum * kNumberOfVideosPerPage, lengthOfRange);
        NSIndexSet *videosToInit = [NSIndexSet indexSetWithIndexesInRange:rangeOfVideos];
        
        videoPage = [[VideoPageViewController alloc] initWithVideos:[videosForCurrentMasterPage objectsAtIndexes:videosToInit]];
        [self.detailViewControllers replaceObjectAtIndex:detailPageNum withObject:videoPage];
    }

    if (videoPage.view.superview == nil)
    {
        CGRect frame = self.detailScrollView.frame;
        frame.origin.x = frame.size.width * detailPageNum;
        frame.origin.y = 0;
        videoPage.view.frame = frame;
        [self.detailScrollView addSubview:videoPage.view];
    }
}

#pragma mark - Core Data Calls

-(NSArray*)loadVideoEntities {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Title like[cd] '*'"];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results == nil)
        NSLog(@"%@", error.description);
    
    return results;
}

//loads some test data, 3 videos added per test category, i.e. category1 = 3 videos, category2 = 6 videos...
-(void)loadTestData
{
    NSMutableArray *testCategories = [[NSMutableArray alloc] init];
    NSMutableArray *testVideos = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < kNumberOfTestCategories; i++) 
    {
        
        NSString *categoryTitle = [NSString stringWithFormat:@"Category%d",i];
        VideoCategory *videoCategory = [NSEntityDescription insertNewObjectForEntityForName:@"VideoCategory" inManagedObjectContext:self.managedObjectContext];
        videoCategory.Name = categoryTitle;
        [testCategories addObject:videoCategory];
        
        NSMutableArray *testVideosForThisCategory = [[NSMutableArray alloc] init];
        for(int y=0; y < (i + 1) * 3; y++)
        {
            Video *testVideo = (Video*)[NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
            testVideo.Title = [NSString stringWithFormat:@"T1", categoryTitle];
            testVideo.Description = @"Test description..."; 
            [testVideosForThisCategory addObject:testVideo];
        }     
        [testVideos addObject:testVideosForThisCategory];
    }
    
    self.categories = [[NSArray alloc] initWithArray:testCategories];
    self.videos = [[NSArray alloc] initWithArray:testVideos];
}

@end