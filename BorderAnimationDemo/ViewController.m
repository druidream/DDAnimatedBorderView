//
//  ViewController.m
//  BoundsAnimation
//
//  Created by Gu Jun on 12/23/15.
//  Copyright (c) 2015 dream. All rights reserved.
//

#import "ViewController.h"
#import "DDAnimatedBorderView.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize borderView;

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(40, 40, 240, 60)];
    [input setBackgroundColor:[UIColor clearColor]];
    input.text = @"animated border";
    input.textColor = [UIColor lightGrayColor];
    input.textAlignment = NSTextAlignmentCenter;
    input.tintColor = [UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f];
    input.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f] CGColor];
    input.layer.borderWidth = 0.5f;
    // delegate for events on focus and blur
    input.delegate = self;
    [self.view addSubview:input];
    
    UITextField *input2 = [[UITextField alloc] initWithFrame:CGRectMake(40, 140, 240, 60)];
    input2.text = @"normal border";
    input2.textColor = [UIColor lightGrayColor];
    input2.textAlignment = NSTextAlignmentCenter;
    input2.tintColor = [UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f];
    input2.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f] CGColor];
    input2.layer.borderWidth = 0.5f;
    [self.view addSubview:input2];
    
    // USAGE
    borderView = [[DDAnimatedBorderView alloc] initWithFrame:input.frame];
    [borderView setBorderWidth:2.0];
    [borderView setBorderColor:[UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f]];
    [borderView setAnimationDuration:1.5f];
    [self.view addSubview:borderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [borderView animateIn];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [borderView animateOut];

}

@end
