//
//  ViewController.m
//  MailMaster
//
//  Created by MADAO on 16/3/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "FHMutiLayerView.h"

@interface ViewController ()<UIGestureRecognizerDelegate,FHMutiLayerDelegate>

@property (nonatomic, strong) FHMutiLayerView *mutiView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];

}

- (void)setupNavigationBar
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view1.backgroundColor = [UIColor clearColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"general_img_arrow_down"] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    button1.tintColor = [UIColor blackColor];
    [view1 addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"general_img_arrow_right"] forState:UIControlStateNormal];
    button2.frame =  CGRectMake(60, 0, 44, 44);
    [view1 addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setImage:[UIImage imageNamed:@"general_img_icon_auth"] forState:UIControlStateNormal];
    button3.frame = CGRectMake(0, 0, 44, 44);
    button3.tintColor = [UIColor blackColor];
    [view1 addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setImage:[UIImage imageNamed:@"general_img_icon_bankcard"] forState:UIControlStateNormal];
    button4.frame =  CGRectMake(60, 0, 44, 44);
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view2.backgroundColor = [UIColor clearColor];
    [view2 addSubview:button3];
    [view2 addSubview:button4];
    
    [button4 addTarget:self action:@selector(openNewVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.mutiView = [[FHMutiLayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) viewArray:@[view1,view2]];
    self.mutiView.fhMViewDelegete = (id<FHMutiLayerDelegate>)self.view;
    self.navigationItem.titleView = self.mutiView;
}

#pragma mark - WidgetsActions
- (void)openNewVC
{
    SecondViewController *newVC = [[SecondViewController alloc] init];
    newVC.view.backgroundColor = [UIColor blackColor];
    [self.mutiView removeFromSuperview];
    [self.navigationController pushViewController:newVC animated:YES];
}

@end
