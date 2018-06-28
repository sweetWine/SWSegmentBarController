//
//  SWSegmentBarController.m
//  TestProject
//
//  Created by sweet wine on 2018/3/12.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import "SWSegmentBarController.h"

@interface ContentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView *contentVisibleView;

@end
@implementation ContentCollectionViewCell

- (void)setContentVisibleView:(UIView *)contentVisibleView
{
    if (_contentVisibleView != contentVisibleView) {
        if ([_contentVisibleView isDescendantOfView:self.contentView]) {
            [_contentVisibleView removeFromSuperview];
        }
        _contentVisibleView = contentVisibleView;
        _contentVisibleView.frame = self.contentView.bounds;
        [self.contentView addSubview:_contentVisibleView];
    }
}

@end

static NSString *collectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface SWSegmentBarController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *contentCollectionView;
@property (nonatomic, strong)NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger willSelectIndex;

@end

@implementation SWSegmentBarController

#pragma mark - getter & setter
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.view.frame.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:flowLayout];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.bounces = NO;
        [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    }
    return _contentCollectionView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        _selectedIndex = MIN(MAX(_selectedIndex, 0), self.viewControllers.count - 1);
        // TODO: 可在此处调用子控制器的viewDidAppear方法
//        [self.viewControllers[_selectedIndex] viewDidAppear:NO];
    }
}

- (void)setWillSelectIndex:(NSInteger)willSelectIndex
{
    if (_willSelectIndex != willSelectIndex) {
        _willSelectIndex = willSelectIndex;
        
        _willSelectIndex = MIN(MAX(_willSelectIndex, 0), self.viewControllers.count - 1);
        // TODO: 可在此处调用子控制器的viewWillAppear方法
//        [self.viewControllers[_willSelectIndex] viewWillAppear:NO];
    }
}

- (SWHollowOutSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        _segmentBar = [[SWHollowOutSegmentBar alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        __weak typeof(self) weakSelf = self;
        _segmentBar.selectedActionBlock = ^(NSInteger index) {
            NSLog(@"%ld",index);
            [weakSelf.contentCollectionView setContentOffset:CGPointMake(index*weakSelf.contentCollectionView.frame.size.width, 0) animated:YES];
        };
    }
    return _segmentBar;
}

// MARK: - 初始化方法
+ (instancetype)createSegmentControllerWithTitles:(NSArray<NSString *> *)titles withViewController:(NSArray<__kindof UIViewController *> *)viewControllers
{
    NSAssert(titles.count == viewControllers.count, @"title数与viewController数目不一致");
    SWSegmentBarController *segmentController = [[[self class] alloc] init];
    segmentController.segmentBar.itemTitleArray = titles;
    segmentController.viewControllers = viewControllers;
    return segmentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    [self.view addSubview:self.contentCollectionView];
    [self.view addSubview:self.segmentBar];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    collectionViewCell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    collectionViewCell.contentVisibleView = self.viewControllers[indexPath.item].view;
    return collectionViewCell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentCollectionView) {
        
        NSInteger contentOffset_x = (NSInteger)ABS(self.selectedIndex * scrollView.frame.size.width - scrollView.contentOffset.x);
        if (scrollView.contentOffset.x < self.selectedIndex * scrollView.frame.size.width) { // ←
            if (contentOffset_x > scrollView.frame.size.width) {
                if (contentOffset_x % (NSInteger)scrollView.frame.size.width == 0) {
                    self.willSelectIndex = self.selectedIndex - contentOffset_x/(NSInteger)scrollView.frame.size.width;
                }else {
                    self.willSelectIndex = self.selectedIndex - contentOffset_x/(NSInteger)scrollView.frame.size.width - 1;
                }
            }else {
                self.willSelectIndex = self.selectedIndex - 1;
            }

        }else { // →
            if (contentOffset_x > scrollView.frame.size.width) {
                if (contentOffset_x % (NSInteger)scrollView.frame.size.width == 0) {
                    self.willSelectIndex = self.selectedIndex + contentOffset_x/(NSInteger)scrollView.frame.size.width;
                }else {
                    self.willSelectIndex = self.selectedIndex + contentOffset_x/(NSInteger)scrollView.frame.size.width + 1;
                }
            }else {
                self.willSelectIndex = self.selectedIndex + 1;
            }
        }
        
        NSLog(@"%ld",self.willSelectIndex);
        
        self.segmentBar.selectedItemContentOffset_x = scrollView.contentOffset.x;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:self.contentCollectionView afterDelay:.1];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentCollectionView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSLog(@"scroll end");
        
        self.selectedIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
        self.willSelectIndex = self.selectedIndex;
        NSLog(@"%ld -- %ld",self.selectedIndex, self.willSelectIndex);
    }
}

@end
