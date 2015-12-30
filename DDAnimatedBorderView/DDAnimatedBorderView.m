//
//  DDAnimatedBorderView.m
//  DDAnimatedBorderView
//
//  Created by Gu Jun on 12/27/15.
//  Copyright © 2015 dream. All rights reserved.
//

#import "DDAnimatedBorderView.h"

@implementation DDAnimatedBorderView
@synthesize borderWidth, borderColor, animationDuration;
@synthesize width, height, progress, startTime, timer, status, remainingProgress;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.userInteractionEnabled = NO;
        status = kAnimationStopped;
        progress = 0;
        
        borderWidth = 1.0;
//        CGFloat color[]={1.0, 0.5, 0.0, 1.0};
//        borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), color);
        borderColor = [UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f];
        animationDuration = 1.5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    const CGFloat *components = CGColorGetComponents(borderColor.CGColor);
    
    if (status == kAnimationMovingIn) {
        progress = [self timingFunction];
        
        width = self.frame.size.width;
        height = self.frame.size.height;
        NSInteger length = width + height;
        NSInteger current = progress * length;
        NSInteger firstSegment = width / 2;
        NSInteger secondSegment = height;
//        NSInteger thirdSegment = width / 2;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);

        CGMutablePathRef path1 = CGPathCreateMutable();
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, NULL, width/2, 0);
        CGPathMoveToPoint(path2, &CGAffineTransformIdentity, width/2, height-0);
        
        if (current > firstSegment) {
            CGPathAddLineToPoint(path1, NULL, 0, 0);
            CGPathAddLineToPoint(path2, &CGAffineTransformIdentity, width, height-0);
            if (current > firstSegment + secondSegment) {
                CGPathAddLineToPoint(path1, NULL, 0, height);
                CGPathAddLineToPoint(path1, NULL, progress * length - firstSegment - secondSegment, height);
                CGPathAddLineToPoint(path2, &CGAffineTransformIdentity, width, 0);
                CGPathAddLineToPoint(path2, &CGAffineTransformIdentity, width - (progress * length - firstSegment - secondSegment), 0);
            } else {
                CGPathAddLineToPoint(path1, NULL, 0, progress * length - firstSegment);
                CGPathAddLineToPoint(path2, &CGAffineTransformIdentity, width, height - (progress * length - firstSegment));
            }
        } else {
            CGPathAddLineToPoint(path1, NULL, firstSegment - progress * length, 0);
            CGPathAddLineToPoint(path2, &CGAffineTransformIdentity, width / 2 + progress * length, height-0);
        }
        CGContextAddPath(ctx, path1);
        CGContextAddPath(ctx, path2);
        CGContextStrokePath(ctx);
        
            CGPathRelease(path1);
            CGPathRelease(path2);
        
        if (progress >= 1) {
            [timer invalidate];
            status = kAnimationStopped;
        }

    } else if (status == kAnimationMovingOut) {
        progress = [self _animationOutTimingFuction];
        
        if (progress > 1) {
            [timer invalidate];
            status = kAnimationStopped;
            return;
        }
        width = self.frame.size.width;
        height = self.frame.size.height;
        NSInteger length = width + height;
        NSInteger current = progress * length;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);
        CGContextSetLineWidth(ctx, borderWidth);
        
        if (remainingProgress < (float)(width/2) / (width+height)) {
            // draw line 1, line 2, part of line 3
            
            CGMutablePathRef path1 = CGPathCreateMutable();
            CGPathMoveToPoint(path1, NULL, width/2, 0);
            CGPathAddLineToPoint(path1, NULL, width/2 * progress, 0);
            CGContextAddPath(ctx, path1);
            
            CGMutablePathRef path4 = CGPathCreateMutable();
            CGPathMoveToPoint(path4, NULL, width/2, height);
            CGPathAddLineToPoint(path4, NULL, width/2 + width/2 * (1-progress), height);
            CGContextAddPath(ctx, path4);
            
            CGPathRelease(path1);
            CGPathRelease(path4);
            
            CGMutablePathRef path2 = CGPathCreateMutable();
            CGPathMoveToPoint(path2, NULL, 0, 0);
            CGPathAddLineToPoint(path2, NULL, 0, height * (1-progress));
            CGContextAddPath(ctx, path2);
            
            CGMutablePathRef path5 = CGPathCreateMutable();
            CGPathMoveToPoint(path5, NULL, width, height);
            CGPathAddLineToPoint(path5, NULL, width, height * progress);
            CGContextAddPath(ctx, path5);
            
            CGPathRelease(path2);
            CGPathRelease(path5);
            
            CGMutablePathRef path3 = CGPathCreateMutable();
            CGPathMoveToPoint(path3, NULL, 0, height);
            CGPathAddLineToPoint(path3, NULL, (width/2 - length * remainingProgress) * (1-progress), height);
            CGContextAddPath(ctx, path3);
            
            CGMutablePathRef path6 = CGPathCreateMutable();
            CGPathMoveToPoint(path6, NULL, width, 0);
            CGPathAddLineToPoint(path6, NULL, width/2 +length * remainingProgress + (width/2-length * remainingProgress)  * progress, 0);
            CGContextAddPath(ctx, path6);
            
            CGPathRelease(path3);
            CGPathRelease(path6);
        } else if (remainingProgress < (float)(width/2+height) / (width+height)) {
            // draw line 1, part of line 2, no line 3
            CGMutablePathRef path1 = CGPathCreateMutable();
            CGPathMoveToPoint(path1, NULL, width/2, 0);
            CGPathAddLineToPoint(path1, NULL, width/2 * progress, 0);
            CGContextAddPath(ctx, path1);
            
            CGMutablePathRef path4 = CGPathCreateMutable();
            CGPathMoveToPoint(path4, NULL, width/2, height);
            CGPathAddLineToPoint(path4, NULL, width/2 + width/2 * (1-progress), height);
            CGContextAddPath(ctx, path4);
            
            CGPathRelease(path1);
            CGPathRelease(path4);

            CGMutablePathRef path2 = CGPathCreateMutable();
            CGPathMoveToPoint(path2, NULL, 0, 0);
            CGPathAddLineToPoint(path2, NULL, 0, (height-length*(remainingProgress-(width/2)/(width+height))) * (1-progress));
            CGContextAddPath(ctx, path2);
            
            CGMutablePathRef path5 = CGPathCreateMutable();
            CGPathMoveToPoint(path5, NULL, width, height);
            CGPathAddLineToPoint(path5, NULL, width, (height-length*(remainingProgress-(width/2)/(width+height))) * progress);
            CGContextAddPath(ctx, path5);
            
            CGPathRelease(path2);
            CGPathRelease(path5);
            
        } else {
            // draw part of line 1, no line 2, no line 3
            CGMutablePathRef path1 = CGPathCreateMutable();
            CGPathMoveToPoint(path1, NULL, width/2, 0);
            CGPathAddLineToPoint(path1, NULL, length*(remainingProgress-(width/2+height)/(width+height))+(width/2-length*(remainingProgress-(width/2+height)/(width+height))) * progress, 0);
            CGContextAddPath(ctx, path1);
            
            CGMutablePathRef path4 = CGPathCreateMutable();
            CGPathMoveToPoint(path4, NULL, width/2, height);
            CGPathAddLineToPoint(path4, NULL, width/2 + (width/2-length*(remainingProgress-(width/2+height)/(width+height))) * (1-progress), height);
            CGContextAddPath(ctx, path4);
            
            CGPathRelease(path1);
            CGPathRelease(path4);
        }
        CGContextStrokePath(ctx);
    }
}

- (void)animateIn
{
    if (status == kAnimationMovingIn) {
        return;
    }
    self.userInteractionEnabled = NO;
    
    status = kAnimationMovingIn;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    startTime = [dat timeIntervalSince1970];
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    timer.frameInterval = 2;
     [timer addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)animateOut
{
    // is animateIn finished
    if (status == kAnimationMovingIn) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now = [dat timeIntervalSince1970];
        remainingProgress = 1 - (now-startTime) / animationDuration;
        if (remainingProgress > 1 || remainingProgress < 0) {
            NSLog(@"wrong remainingProgress value: %f", remainingProgress);
            remainingProgress = 0;
        }
    } else {
        remainingProgress = 0;
    }
    
    status = kAnimationMovingOut;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    startTime = [dat timeIntervalSince1970];
    [timer invalidate];
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    timer.frameInterval = 2;
    [timer addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (CGFloat)_animationOutTimingFuction
{
    return [self timingFunction] * 3;
}

- (CGFloat)timingFunction
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970];
    return (now - startTime) / animationDuration;
}

@end
