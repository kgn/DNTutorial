//
//  DNTutorial.h
//  DNTutorial
//
//  Created by Daniel Niemeyer on 7/24/14.
//  Copyright (c) 2014 Daniel Niemeyer. All rights reserved.
//

// App tutorial manages a set of tutorial messages that interact with the user.
// Once the user completes a task, the tutotial message will never be displayed again.
// If the user interacts with a feature that could toggle a tutorial message, that message
//   should never be displayed to the user.
// App tutorial provides incentives for users to complete tutorials by displaying their progress overall

// Tutorials consist of multiple types.
// DNTutorialBanner displays a banner with an appropriate message and an action that triggers its dismissal.
// DNTutorialGesture displays a gesture motion with a starting location and direction.
// DNTutorialBoth displays a gesture montion alongside a banner with a progress banner

#import <Foundation/Foundation.h>

#import "DNTutorialStep.h"

#import "DNTutorialBanner.h"
#import "DNTutorialGesture.h"

@class DNTutorial;

@protocol DNTutorialDelegate;

@interface DNTutorial : NSObject <DNTutorialStepDelegate>
{
    @private
    __weak id<DNTutorialDelegate>   _delegate;
}

// AppTutorial is delegate based, with functions notifying the delegate of user interactions with banners
@property (nonatomic, weak) id<DNTutorialDelegate>  delegate;


// Shared instance
+ (DNTutorial *)sharedInstance;

- (void)presentTutorialWithSteps:(NSArray *)tutorialSteps
                            inView:(UIView *)aView
                          delegate:(id<DNTutorialDelegate>)delegate;

// Triggers a user action as completed
- (void)completedStepForKey:(NSString *)aKey;


// Reset tutorial to factory settings
- (void)resetProgress;


// Used for tutorial gesture
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@protocol DNTutorialDelegate <NSObject>

@optional
- (void)willDismissView:(DNTutorialElement *)view;
- (void)didDismissView:(DNTutorialElement *)view;

- (BOOL)shouldDismissElement:(DNTutorialElement *)element;

- (BOOL)shouldPresentStep:(DNTutorialStep *)step forKey:(NSString *)aKey;

@end