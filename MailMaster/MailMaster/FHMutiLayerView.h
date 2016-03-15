//
//  FHMutiLayerButtonView.h
//  MailMaster
//
//  Created by MADAO on 16/3/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FHMutiLayerDelegate<NSObject>

@end

@interface FHMutiLayerView : UIScrollView

@property (nonatomic, weak) id<FHMutiLayerDelegate> fhMViewDelegete;

- (instancetype)initWithFrame:(CGRect)frame viewArray:(NSArray *)viewArray;

//- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonsArray;

@end

