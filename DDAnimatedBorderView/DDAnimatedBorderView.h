//
//  DDAnimatedBorderView.h
//  DDAnimatedBorderView
//
//  Created by Gu Jun on 12/27/15.
//  Copyright © 2015 dream. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnimationStatus) {
    kAnimationStopped,
    kAnimationMovingIn,
    kAnimationMovingOut
};

@interface DDAnimatedBorderView : UIView

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGColorRef borderColor;
@property (nonatomic) float animationDuration;

@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) float progress;
@property (nonatomic) float remainingProgress;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) CADisplayLink *timer;
@property (nonatomic) AnimationStatus status;

- (void)animateIn;
- (void)animateOut;

@end
