//
//  SWHollowOutSegmentBar.m
//  TestProject
//
//  Created by sweet wine on 2018/6/26.
//  Copyright © 2018年 sweet wine. All rights reserved.
//

#import "SWHollowOutSegmentBar.h"

@interface HollowOutLabel : UILabel
@end
@implementation HollowOutLabel

//- (void)drawRect:(CGRect)rect
//{
//    [self setTextColor:[UIColor whiteColor]];
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGImageRef image = CGBitmapContextCreateImage(context);
//    UIGraphicsEndImageContext();
//    context = UIGraphicsGetCurrentContext();
//    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect)));
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetBitsPerPixel(image), CGImageGetBytesPerRow(image), CGImageGetDataProvider(image), CGImageGetDecode(image), CGImageGetShouldInterpolate(image));
//    CFRelease(image); image = NULL;
//    CGContextClearRect(context, rect);
//    CGContextSaveGState(context);
//    CGContextClipToMask(context, rect, mask);
//    CFRelease(mask); mask = NULL;
//    CGContextRef bgContext = UIGraphicsGetCurrentContext();
//    [[UIColor whiteColor] set];
//    CGContextFillRect(bgContext, rect);
//    CGContextRestoreGState(context);
//
//}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetBlendMode(contextRef, kCGBlendModeDestinationOut);
    
    CGRect testRect = rect;
    testRect.size.height = 42;
    UILabel *label = [[UILabel alloc] initWithFrame:testRect];
    label.font = self.font;
    label.text = self.text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = self.backgroundColor;
    [label.layer drawInContext:contextRef];
    
    CGContextRestoreGState(contextRef);
}

@end

@interface SWHollowOutSegmentBar ()
@property (nonatomic, strong)UIView *selectedItemBackgroundView;
@property (nonatomic, strong)NSMutableArray *titleWidthArray;
@property (nonatomic, assign)NSInteger currentSelectedIndex;
@property (nonatomic, assign)CGFloat unitWidth;
@end
@implementation SWHollowOutSegmentBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.currentSelectedIndex = 0;
    }
    return self;
}

- (void)setNormalItemColor:(UIColor *)normalItemColor
{
    _normalItemColor = normalItemColor;
    self.backgroundColor = normalItemColor;
}

- (void)setSelectedItemColor:(UIColor *)selectedItemColor
{
    _selectedItemColor = selectedItemColor;
    self.selectedItemBackgroundView.backgroundColor = selectedItemColor;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray
{
    _itemTitleArray = itemTitleArray;
    CGFloat unitWidth = self.frame.size.width / itemTitleArray.count;
    for (NSString *title in itemTitleArray) {
        CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(1000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
        if (titleWidth > unitWidth) {
            [self.titleWidthArray addObject:@(unitWidth)];
        }else {
            [self.titleWidthArray addObject:@(titleWidth + 2)];
        }
    }
    [self addSubview:self.selectedItemBackgroundView];
    [self createSelectItems];
}

- (void)setSelectedItemContentOffset_x:(CGFloat)selectedItemContentOffset_x
{
    _selectedItemContentOffset_x = selectedItemContentOffset_x;
    
    CGFloat contentOffsetScale = selectedItemContentOffset_x / [UIScreen mainScreen].bounds.size.width;
    self.currentSelectedIndex = (NSInteger)contentOffsetScale;
    CGFloat currentTitleWidth = [self.titleWidthArray[self.currentSelectedIndex] floatValue];
    CGFloat nextTitleWidth;
    if (self.currentSelectedIndex == self.titleWidthArray.count - 1) {
        nextTitleWidth = [self.titleWidthArray[self.currentSelectedIndex] floatValue];
    }else {
        nextTitleWidth = [self.titleWidthArray[self.currentSelectedIndex+1] floatValue];
    }
    
    CGRect backViewRect = self.selectedItemBackgroundView.frame;
    backViewRect.size.width = (nextTitleWidth - currentTitleWidth) * (contentOffsetScale - self.currentSelectedIndex) + currentTitleWidth;
    self.selectedItemBackgroundView.frame = backViewRect;
    
    self.selectedItemBackgroundView.center = CGPointMake(self.unitWidth * (contentOffsetScale + .5), self.selectedItemBackgroundView.center.y);
}

- (CGFloat)unitWidth
{
    return self.frame.size.width / self.itemTitleArray.count;
}

- (NSMutableArray *)titleWidthArray
{
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _titleWidthArray;
}

- (UIView *)selectedItemBackgroundView
{
    if (!_selectedItemBackgroundView) {
        _selectedItemBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.titleWidthArray[0] floatValue], self.frame.size.height)];
        _selectedItemBackgroundView.backgroundColor = [UIColor blueColor];
        _selectedItemBackgroundView.center = CGPointMake(self.unitWidth/2, _selectedItemBackgroundView.center.y);
    }
    return _selectedItemBackgroundView;
}

- (void)createSelectItems
{
    for (int i = 0; i < self.itemTitleArray.count; i++) {
        HollowOutLabel *selectItemLabel = [[HollowOutLabel alloc] initWithFrame:CGRectMake(self.unitWidth*i, 0, self.unitWidth, self.frame.size.height-2)];
        selectItemLabel.tag = 180626 + i;
        selectItemLabel.backgroundColor = [UIColor whiteColor];
        selectItemLabel.text = self.itemTitleArray[i];
        selectItemLabel.textAlignment = NSTextAlignmentCenter;
        selectItemLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:selectItemLabel];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInView:self];
    self.selectedActionBlock((NSInteger)(touchLocation.x/self.unitWidth));
}

@end
