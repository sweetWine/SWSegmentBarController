//
//  SWSegmentBarController.h
//  TestProject
//
//  Created by sweet wine on 2018/3/12.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWHollowOutSegmentBar.h"

@interface SWSegmentBarController : UIViewController

@property (nonatomic, strong)SWHollowOutSegmentBar *segmentBar;

+ (instancetype)createSegmentControllerWithTitles:(NSArray<NSString *> *)titles withViewController:(NSArray<__kindof UIViewController *> *)viewControllers;

@end
