//
//  TestTwoViewController.m
//  SegmentBarProject
//
//  Created by sweet wine on 2018/6/28.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import "TestTwoViewController.h"

@interface TestTwoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger currentNum;

@end

@implementation TestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    self.currentNum = -1;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak_self.tableView reloadData];
    });
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weak_self.currentNum++;
        if (weak_self.currentNum >= weak_self.dataSource.count) {
            weak_self.currentNum--;
            [timer invalidate];
            timer = nil;
        } else {
            [weak_self.tableView beginUpdates];
            [weak_self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weak_self.currentNum inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [weak_self.tableView endUpdates];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return self.currentNum+1;
    }else if (section == 2) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"Cell_0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"this is %@ row",self.dataSource[indexPath.row]];
        cell.backgroundColor = [UIColor cyanColor];
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *identifier = @"Cell_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"this is %@ row",self.dataSource[indexPath.row]];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        return cell;
    }else if (indexPath.section == 2) {
        static NSString *identifier = @"Cell_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"this is %@ row",self.dataSource[indexPath.row]];
        cell.backgroundColor = [UIColor greenColor];
        return cell;
    }
    return nil;
}


@end
