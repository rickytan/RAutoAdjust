//
//  ViewController.m
//  RAutoAdjust
//
//  Created by ricky on 13-3-22.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "ViewController.h"
#import "RAutoTextView.h"

@interface ViewController ()
@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet RAutoTextView *textView2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSString *str = @"<html><body>This is <font color='red'>simple</font><img src=\"https://www.google.com/images/srpr/logo4w.png\"><h1>Header</h1><img src=\"http://www.logoair.com/wp-content/uploads/2011/02/002.gif\"></body</html>";
    [self.textView setValue:str forKey:@"contentToHTMLString"];
    self.textView.textAlignment = NSTextAlignmentLeft;
    //self.textView.attributedText
    //self.textView.editable = NO;
    self.textView.font = [UIFont fontWithName:@"vardana" size:20.0];


    self.textView2.visibleLinesWhenKeyboardOverlay = 4.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (IBAction)onDismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_textView2 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextView2:nil];
    [super viewDidUnload];
}
@end
