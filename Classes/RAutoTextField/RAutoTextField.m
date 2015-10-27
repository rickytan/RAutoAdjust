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

/*
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
 */
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreMainView:)
                                                 name:UIKeyboardWillHideNotification
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
            if (CGRectGetMaxY(frame) > keyboardFrame.origin.y - [self adjustDistance]) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - CGRectGetMaxY(frame) - [self adjustDistance]);
            }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if (CGRectGetMinY(frame) < keyboardFrame.size.height + [self adjustDistance]) {
                transform = CGAffineTransformMakeTranslation(0, keyboardFrame.size.height - CGRectGetMinY(frame) + [self adjustDistance]);
            }
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (CGRectGetMinX(frame) < keyboardFrame.size.width + [self adjustDistance]) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.size.width - CGRectGetMinX(frame) + [self adjustDistance], 0);
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (CGRectGetMaxX(frame) > keyboardFrame.origin.x - [self adjustDistance]) {
                transform = CGAffineTransformMakeTranslation(keyboardFrame.origin.x - CGRectGetMaxX(frame) - [self adjustDistance], 0);
            }
            break;
        default:
            break;
    }

    [UIView animateKeyframesWithDuration:duration
                                   delay:0.f
                                 options:UIViewAnimationOptionBeginFromCurrentState | (curve << 16)
                              animations:^{

                                  self.window.transform = transform;
                              }
                              completion:^(BOOL finished) {

                              }];
}

- (void)restoreMainView:(NSNotification *)notification
{
    if (!self.isFirstResponder)
        return;

    NSDictionary *userinfo = notification.userInfo;

    NSInteger curve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat duration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewAnimationOptionBeginFromCurrentState | (curve << 16)
                              animations:^{
                                  self.window.transform = CGAffineTransformIdentity;
                              }
                              completion:NULL];

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
