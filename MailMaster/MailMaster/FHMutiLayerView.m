//
//  FHMutiLayerButtonView.m
//  MailMaster
//
//  Created by MADAO on 16/3/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHMutiLayerView.h"
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FHMutiLayerStateUp = 0,
    FHMutiLayerStateDown,
} FHMutiLayerState;

typedef enum : NSInteger{
    FHMutiLayerDirectionLeft = 0,
    FHMutiLayerDirectionRight,
    FHMutiLayerDirectionUp,
    FHMutiLayerDirectionDown,
    FHMutiLayerDirectionNone
}FHMutiLayerDirection;
@interface FHMutiLayerView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView  *mainScrollView;

@property (nonatomic, assign) FHMutiLayerState state;
@property (nonatomic, assign) FHMutiLayerDirection direction;

/**子视图数组*/
@property (nonatomic, strong) NSArray *viewsArray;

@property (nonatomic, assign) CGPoint lastTranslation;

/**PanGesture*/
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecongnizer;

@end


@implementation FHMutiLayerView
- (void)setFhMViewDelegete:(id<FHMutiLayerDelegate>)fhMViewDelegete
{
    _fhMViewDelegete = fhMViewDelegete;
    [self setupDelegate];
}
- (instancetype)initWithFrame:(CGRect)frame viewArray:(NSArray *)viewArray
{
    if (self = [super initWithFrame:frame])
    {
        self.viewsArray = viewArray;
        self.state = FHMutiLayerStateUp;
        self.direction = FHMutiLayerDirectionNone;
        self.lastTranslation = CGPointZero;
        [self setupMainScrollView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonsArray
//{
//    for (NSArray *subButtonArray in buttonsArray) {
//#warning todo
//    }
//    return self;
//}
//
///**User Interface*/
//- (UIView *)setupViewWithButton
//{
//#warning todo
//    return nil;
//}

- (void)setupMainScrollView
{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 , self.frame.size.width, self.frame.size.height)];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *currentView;
    UIView *lastView;
    for (int i = 0; i < self.viewsArray.count; i++) {
        id obj = self.viewsArray[i];
        NSAssert([obj isKindOfClass:[UIView class]] , @"the Object is not kind of View Class In Array!");
        currentView = (UIView *)obj;
        if (i == 0) {
            currentView.frame = CGRectMake(0, 0, currentView.frame.size.width, currentView.frame.size.height);
        }
        else
        {
            currentView.frame = CGRectMake(0,CGRectGetMaxY(lastView.frame), currentView.frame.size.width, currentView.frame.size.height);
        }
        [self.mainScrollView addSubview:currentView];
        lastView = currentView;
    }
    self.mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastView.frame), CGRectGetMaxY(lastView.frame));
    [self addSubview:self.mainScrollView];
}

#pragma mark - Delegate
- (void)setupDelegate
{
    NSAssert([self.fhMViewDelegete isKindOfClass:[UIView class]], @"The Delegate Must be a kind of View!");
    NSAssert(![self.fhMViewDelegete isKindOfClass:[UITableView class]],@"Sorry, U should use  XX because of the confict of gesture");
    UIView *delegateView = (UIView *)self.fhMViewDelegete;
    UIPanGestureRecognizer *panGR;
    for (id obj in delegateView.gestureRecognizers) {
        NSLog(@"%@",obj);
        if ([obj isMemberOfClass:[UIPanGestureRecognizer class]])
        {
            panGR = (UIPanGestureRecognizer *)obj;
            [panGR addTarget:self action:@selector(panTheMainScrollView:)];
            break;
        }
    }
    if (panGR == nil) {
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTheMainScrollView:)];
        panGR.delegate = self;
        self.panGestureRecongnizer = panGR;
        [delegateView addGestureRecognizer:panGR];
    }

}
- (void)panTheMainScrollView:(UIPanGestureRecognizer *)panGestureRecongnizer
{
    CGPoint translation = [panGestureRecongnizer translationInView:(UIView *)self.fhMViewDelegete];
    /**判断方向*/
    if (translation.x > 0) {
        self.direction = FHMutiLayerDirectionRight;
    }
    else
    {
        self.direction = FHMutiLayerDirectionLeft;
    }
    
    UIView *firstView = self.viewsArray[0];
    UIView *secondView = self.viewsArray[1];
    if (panGestureRecongnizer.state == UIGestureRecognizerStateBegan)
    {
        if (translation.y != 0 )
        {
            self.lastTranslation = translation;
            return;
        }
    }
    else if (panGestureRecongnizer.state == UIGestureRecognizerStateEnded)
    {
        /**手势结束*/
        if (translation.x > self.mainScrollView.frame.size.height)
        {
            [self.mainScrollView setContentOffset:CGPointMake(0,self.mainScrollView.frame.size.height) animated:YES];
            self.state = FHMutiLayerStateDown;
            firstView.alpha = 0;
            secondView.alpha = 1;
        }
        else
        {
            [self.mainScrollView setContentOffset:CGPointZero animated:YES];
            self.state = FHMutiLayerStateUp;
            firstView.alpha = 1;
            secondView.alpha = 0;
        }

        self.lastTranslation = translation;
        return;
    }
    else if (panGestureRecongnizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newOffset = CGPointMake(0,translation.x/2);
        if (self.state == FHMutiLayerStateUp)
        {
            newOffset = CGPointMake(0,translation.x/2);
        }
        else
        {
            newOffset = CGPointMake(0, self.mainScrollView.frame.size.height + translation.x/2);
        }
        firstView.alpha = (1 - newOffset.y/self.frame.size.height);
        secondView.alpha = newOffset.y/self.frame.size.height;
        if (newOffset.y > self.mainScrollView.frame.size.height || newOffset.y < 0 )
        {
            self.lastTranslation = translation;
            return;
        }
    self.mainScrollView.contentOffset = newOffset;
        self.lastTranslation = translation;
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
