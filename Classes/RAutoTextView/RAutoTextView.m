//
//  RAutoTextView.m
//  RAutoAdjust
//
//  Created by ricky on 13-3-22.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RAutoTextView.h"

@implementation RAutoTextView
@synthesize visibleLinesWhenKeyboardOverlay;

- (void)commonInit
{
    self.visibleLinesWhenKeyboardOverlay = 2.0;
    [self registeNotification];
}

- (void)dealloc
{
    [self unregisteNotification];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (BOOL)resignFirstResponder
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.window.transform = CGAffineTransformIdentity;
                         self.contentInset = UIEdgeInsetsZero;
                     }];
    return [super resignFirstResponder];
}

- (UIView*)inputAccessoryView
{
    if ([super inputAccessoryView])
        return [super inputAccessoryView];
    else {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(onDone:)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
        toolbar.items = [NSArray arrayWithObjects:spacer, doneItem, nil];
        RARelease(spacer),RARelease(doneItem);
        self.inputAccessoryView = toolbar;
        return RAAutorelease(toolbar);
    }
}

- (void)onDone:(id)sender
{
    [self resignFirstResponder];
}

- (void)registeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionMainView:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)unregisteNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)adjustPositionWithKeyboardFrame:(CGRect)keyboardFrame
                               duration:(CGFloat)duration
{
    CGRect frame = [self.window convertRect:self.frame
                                   fromView:self.superview];
    CGFloat maxY = CGRectGetMaxY(frame);
    CGFloat minY = CGRectGetMinY(frame) +
    MIN(self.font.lineHeight * self.visibleLinesWhenKeyboardOverlay,
        CGRectGetHeight(frame));
    
    [UIView beginAnimations:@"Adjust" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:0];
    if (minY <= keyboardFrame.origin.y && keyboardFrame.origin.y < maxY) {
        self.contentInset = UIEdgeInsetsMake(0, 0, maxY - keyboardFrame.origin.y, 0);
    }
    else if (minY > keyboardFrame.origin.y) {
        self.window.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - minY);
        self.contentInset = UIEdgeInsetsMake(0, 0, maxY - minY, 0);
    }
    else {
        self.window.transform = CGAffineTransformIdentity;
        self.contentInset = UIEdgeInsetsZero;
    }
    
    [UIView commitAnimations];
}

- (void)positionMainView:(NSNotification*)notification
{
    if (!self.isFirstResponder)
        return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(doAdjust)
                                               object:nil];
    
    NSDictionary *userinfo = notification.userInfo;
    
    CGFloat duration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjustPositionWithKeyboardFrame:keyboardFrame
                                 duration:duration];
}
@end
