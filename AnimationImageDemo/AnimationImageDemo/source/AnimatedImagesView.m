//
//  AnimatedImagesView.m
//  AnimationImageDemo
//
//  Created by liujiafei on 13-5-9.
//  Copyright (c) 2013年 liujiafei. All rights reserved.
//

#import "AnimatedImagesView.h"
#import "LTransitionImageView.h"

#define AnimaterImageTransitionDuration       5.0f
#define AnimatedImagesViewImageViewsBorderOffset  30

@interface AnimatedImagesView ()

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, retain)  LTransitionImageView *imageView;
@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic) NSUInteger currentImageIndex;
@property (nonatomic, strong) NSMutableArray *btnArr;

@end

@implementation AnimatedImagesView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

//init data
- (void)initData
{
    self.imageView = [[LTransitionImageView alloc] initWithFrame:CGRectInset(self.bounds, -AnimatedImagesViewImageViewsBorderOffset, -AnimatedImagesViewImageViewsBorderOffset)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
    self.transitionDuration = AnimaterImageTransitionDuration;
    _currentImageIndex = 0;
    _showNavigator = YES;
}

//init navigator
- (void)initNavigator
{
    _btnArr = [[NSMutableArray alloc] init];
    CGSize spaceSize = CGSizeMake(10, 0);
    CGSize btnSize = CGSizeMake(40, 30);
    for (int i = self.imagesArray.count; i > 0; i--)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-(btnSize.width+spaceSize.width)*(self.imagesArray.count + 1-i), CGRectGetHeight(self.frame)-btnSize.height, btnSize.width, btnSize.height)];
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:[NSString stringWithFormat:@"%i",i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnArr addObject:btn];
    }
}

- (void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    _currentImageIndex = btn.tag - 1;
    [self updateBtnProperty];
    [self startTimerAndDisplayImage];
}

//update button with cuurentImageIndex
- (void)updateBtnProperty
{
    for (UIButton *button in _btnArr)
    {
        if (button.tag == _currentImageIndex + 1)
        {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

//set animation images
- (void)setImagesArr:(NSArray*)images
{
    if (self.imagesArray != nil)
    {
        self.imagesArray = nil;
    }
    if (images != nil && images.count != 0)
    {
       self.imagesArray = images;
    }
    else
    {
        return;
    }
    
}

//start animating
- (void)startAnimating
{
    //judge whether need init navigator with BOOL showNavigator
    if (_showNavigator)
    {
        [self initNavigator];
    }
    [self startTimerAndDisplayImage];
}

- (void)startTimerAndDisplayImage
{
    if (self.playTimer != nil)
    {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
    [self playImageWithCurrentImageIndex];
    NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:self.transitionDuration target:self selector:@selector(playImageWithCurrentImageIndex) userInfo:nil repeats:YES];
    self.playTimer = tempTimer;
}

//stop animating
- (void)stopAnimating
{
   if (self.playTimer != nil)
   {
       [self.playTimer invalidate];
       self.playTimer = nil;
   }
    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.imageView.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         _currentImageIndex = 0;
     }];
}

- (void)playImageWithCurrentImageIndex
{
    if (_showNavigator)
    {
      [self updateBtnProperty];
    }
    
   self.imageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:_currentImageIndex]];
    self.imageView.animationDirection= [self randomImageViewAnimationDirection];
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    /* Move image animation */
    [UIView animateWithDuration:self.transitionDuration + kMovementAndTransitionTimeOffset
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^
     {
         NSInteger randomTranslationValueX = [[self class] randomIntBetweenNumber:0 andNumber:AnimatedImagesViewImageViewsBorderOffset] - AnimatedImagesViewImageViewsBorderOffset;
         NSInteger randomTranslationValueY = [[self class] randomIntBetweenNumber:0 andNumber:AnimatedImagesViewImageViewsBorderOffset] - AnimatedImagesViewImageViewsBorderOffset;
         
         CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
         
         CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120]/100;
         
         CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
         
         self.imageView.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
     }
                     completion:NULL];

    if (self.currentImageIndex < self.imagesArray.count - 1)
    {
        self.currentImageIndex ++;
    }
    else
    {
        self.currentImageIndex = 0;
    }
}

#pragma mark - Random Numbers

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    return i;
}

- (AnimationDirection)randomImageViewAnimationDirection
{
    NSUInteger i = (arc4random() %4);
    return i;
}

@end
