//
//  AnimatedImagesView.h
//  AnimationImageDemo
//
//  Created by liujiafei on 13-5-9.
//  Copyright (c) 2013年 liujiafei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedImagesView : UIView

/*
 * @default AnimaterImageTransitionDuration
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/*
 * judge whether need show navigator
 * @defalut YES;
 */
@property (nonatomic) BOOL showNavigator;

- (void)setImagesArr:(NSArray*)images;
- (void)startAnimating;
- (void)stopAnimating;

@end
