//
//  TestOneViewController.m
//  SegmentBarProject
//
//  Created by sweet wine on 2018/6/28.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import "TestOneViewController.h"

@interface TestOneViewController ()

@end

@implementation TestOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    label.text = self.contentString;
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}



@end
