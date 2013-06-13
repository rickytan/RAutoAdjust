//
//  RAutoTextField.m
//  RAutoAdjust
//
//  Created by ricky on 13-3-22.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RAutoTextField.h"

@implementation RAutoTextField

- (void)commonInit
{
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
    if ([super resignFirstResponder]) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.window.transform = CGAffineTransformIdentity;
                         }];
        return YES;
    }
    return NO;
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
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
            if (CGRectGetMaxY(frame) > keyboardFrame.origin.y) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - CGRectGetMaxY(frame));
            }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            if (CGRectGetMinY(frame) < keyboardFrame.size.height) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.size.height - CGRectGetMinY(frame));
            }
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (CGRectGetMinX(frame) < keyboardFrame.size.width) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.size.width - CGRectGetMinX(frame), 0);
            }
            break;
        case UIDeviceOrientationLandscapeRight:
            if (CGRectGetMaxX(frame) > keyboardFrame.origin.x) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.origin.x - CGRectGetMaxX(frame), 0);
            }
            break;
        default:
            break;
    }
    [UIView beginAnimations:@"Adjust" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:0];
    
    self.window.transform = transform;
    
    [UIView commitAnimations];
}

- (void)positionMainView:(NSNotification*)notification
{
    if (!self.isFirstResponder)
        return;
    
    NSDictionary *userinfo = notification.userInfo;
    
    CGFloat duration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjustPositionWithKeyboardFrame:keyboardFrame
                                 duration:duration];
}

@end
