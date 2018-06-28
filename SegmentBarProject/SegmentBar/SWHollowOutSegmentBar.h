//
//  SWHollowOutSegmentBar.h
//  TestProject
//
//  Created by sweet wine on 2018/6/26.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWHollowOutSegmentBar : UIView

@property (nonatomic, strong)NSArray *itemTitleArray;
@property (nonatomic, copy)void (^selectedActionBlock)(NSInteger index);
@property (nonatomic, assign)CGFloat selectedItemContentOffset_x;

@property (nonatomic, strong)UIColor *normalItemColor;
@property (nonatomic, strong)UIColor *selectedItemColor;

@end
