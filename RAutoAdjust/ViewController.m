//
//  ViewController.m
//  RAutoAdjust
//
//  Created by ricky on 13-3-22.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onHideKeyboard:(id)sender
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(resignFirstResponder)];
}

@end
