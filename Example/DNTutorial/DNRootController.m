//
//  DNRootController.m
//  DNTutorial
//
//  Created by Daniel Niemeyer on 7/29/14.
//  Copyright (c) 2014 Daniel Niemeyer. All rights reserved.
//

#import "DNRootController.h"

#import "DNViewController.h"

@interface DNRootController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation DNRootController


#pragma mark --
#pragma mark Initialization
#pragma mark --

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUInteger numberPages = 2;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    // Tutorial
    [self presentTutorial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark DNTutorial Delegate
#pragma mark --

- (void)presentTutorial;
{
    CGPoint center = self.view.center;
    center.x += 50;
    
    DNTutorialBanner *banner = [DNTutorialBanner bannerWithMessage:@"Tap and hold on the graph to view the value, move your finger left and right to see how the value changes over the day." key:@"initialBanner"];
    [banner styleWithColor:[UIColor blackColor] completedColor:[UIColor blueColor] opacity:0.7 font:[UIFont systemFontOfSize:13]];

    DNTutorialBanner *banner1 = [DNTutorialBanner bannerWithMessage:@"Congratulations! You now know how to interact with graphs in the app. " key:@"doneBanner"];
    [banner1 styleWithColor:[UIColor blackColor] completedColor:[UIColor blueColor] opacity:0.7 font:[UIFont systemFontOfSize:13]];
    [banner1 setCompleted:YES animated:NO];
    
    DNTutorialGesture *gesture = [DNTutorialGesture gestureWithPosition:center direction:DNTutorialGestureDirectionLeft key:@"initialGesture"];
    
    DNTutorialStep *step = [DNTutorialStep stepWithTutorialElements:@[banner, gesture] forKey:@"firtStep"];
    DNTutorialStep *step2 = [DNTutorialStep stepWithTutorialElements:@[banner1] forKey:@"secondStep"];
    
    [[DNTutorial sharedInstance] presentTutorialWithSteps:@[step, step2] inView:self.view delegate:self];
}

- (BOOL)shouldDismissElement:(DNTutorialElement *)element;
{
    return ![element.key isEqualToString:@"doneBanner"];
}

- (BOOL)shouldPresentStep:(DNTutorialStep *)step forKey:(NSString *)aKey;
{
//    return [aKey isEqualToString:@"secondStep"];
    return YES;
}

#pragma mark --
#pragma mark ScrollView
#pragma mark --

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= 2)
        return;
    
    DNViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"DNViewController"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[DNTutorial sharedInstance] scrollViewWillBeginDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[DNTutorial sharedInstance] scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[DNTutorial sharedInstance] scrollViewDidEndDecelerating:scrollView];
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

#pragma mark --
#pragma mark Pagination
#pragma mark --

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];
}

@end