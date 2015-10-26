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

- (UIView *)inputAccessoryView
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
        RARelease(spacer);
        RARelease(doneItem);
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

- (CGFloat)adjustDistance
{
    return 0.f;
}

- (void)adjustPositionWithKeyboardFrame:(CGRect)keyboardFrame
                               duration:(CGFloat)duration
                                  curve:(UIViewAnimationCurve)curve
{
    CGRect frame = [self.window convertRect:self.frame
                                   fromView:self.superview];
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
            if (CGRectGetMaxY(frame) > keyboardFrame.origin.y) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - CGRectGetMaxY(frame) - [self adjustDistance]);
            }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if (CGRectGetMinY(frame) < keyboardFrame.size.height) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.size.height - CGRectGetMinY(frame) + [self adjustDistance]);
            }
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (CGRectGetMinX(frame) < keyboardFrame.size.width) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.size.width - CGRectGetMinX(frame) + [self adjustDistance], 0);
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (CGRectGetMaxX(frame) > keyboardFrame.origin.x) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.origin.x - CGRectGetMaxX(frame) - [self adjustDistance], 0);
            }
            break;
        default:
            break;
    }
    [UIView beginAnimations:@"Adjust" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    self.window.transform = transform;
    
    [UIView commitAnimations];
}

- (void)positionMainView:(NSNotification *)notification
{
    if (!self.isFirstResponder)
        return;
    
    NSDictionary *userinfo = notification.userInfo;

    NSInteger curve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat duration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjustPositionWithKeyboardFrame:keyboardFrame
                                 duration:duration
                                    curve:curve];
}

@end
