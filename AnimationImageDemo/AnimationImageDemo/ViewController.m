//
//  ViewController.m
//  AnimationImageDemo
//
//  Created by liujiafei on 13-5-9.
//  Copyright (c) 2013年 liujiafei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = [NSArray arrayWithObjects:
                            @"image1.jpg",@"image2.jpg",@"image3.jpg", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
