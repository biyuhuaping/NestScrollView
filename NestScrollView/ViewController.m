//
//  ViewController.m
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import "ViewController.h"
#import "TopView.h"
#import "FirstTableView.h"
#import "SecondTableView.h"

#define kItemheight 50
#define kTopViewHeight 200

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) TopView *topView;
@property (strong, nonatomic) FirstTableView *firstTableView;
@property (strong, nonatomic) SecondTableView *secondTableView;
@property (strong, nonatomic) UIScrollView *bottomScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bottomScrollView];
    [self.view addSubview:self.topView];
}

#pragma mark - 底部的scrollViuew的代理方法scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat placeholderOffset = 0;
    if (self.topView.selectedIndex == 0) {
        if (self.firstTableView.contentOffset.y > CGRectGetHeight(self.topView.frame) - kItemheight) {
            placeholderOffset = CGRectGetHeight(self.topView.frame) - kItemheight;
        }else {
            placeholderOffset = self.firstTableView.contentOffset.y;
        }
        [self.secondTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }else {
        if (self.secondTableView.contentOffset.y > CGRectGetHeight(self.topView.frame) - kItemheight) {
            placeholderOffset = CGRectGetHeight(self.topView.frame) - kItemheight;
        }else {
            placeholderOffset = self.secondTableView.contentOffset.y;
        }
        [self.firstTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = ceilf(scrollView.contentOffset.x / kScreenWidth);
    self.topView.selectedIndex = index;
}

#pragma mark - lazy
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        
        [scroll addSubview:self.firstTableView];
        [scroll addSubview:self.secondTableView];
        _bottomScrollView = scroll;
    }
    return _bottomScrollView;
}


- (TopView *)topView{
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
        _topView.itemHeight = kItemheight;
        __weak typeof(self) WS = self;
        _topView.block = ^(NSInteger index) {
            if (index == 0) {
                [WS.bottomScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                WS.topView.selectedIndex = 0;
            }else{
                [WS.bottomScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
                WS.topView.selectedIndex = 1;
            }
        };
    }
    return _topView;
}


- (FirstTableView *)firstTableView{
    if (!_firstTableView) {
        _firstTableView = [[FirstTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _firstTableView.topViewH = CGRectGetHeight(self.topView.frame);
        __weak typeof(self) WS = self;
        _firstTableView.scrollBlock = ^(UIScrollView *scrollView) {
            [WS updateTopViewFrame:scrollView];
        };
    }
    return _firstTableView;
}


- (SecondTableView *)secondTableView{
    if (!_secondTableView) {
        CGRect frame = self.view.bounds;
        frame.origin.x = kScreenWidth;
        _secondTableView = [[SecondTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _secondTableView.topViewH = CGRectGetHeight(self.topView.frame);
        __weak typeof(self) WS = self;
        _secondTableView.scrollBlock = ^(UIScrollView *scrollView) {
            [WS updateTopViewFrame:scrollView];
        };
    }
    return _secondTableView;
}

- (void)updateTopViewFrame:(UIScrollView *)scrollView{
    CGFloat placeHolderHeight = CGRectGetHeight(self.topView.frame) - self.topView.itemHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGRect frame = self.topView.frame;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        frame.origin.y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        frame.origin.y = - placeHolderHeight;
    } else if (offsetY <0) {
        frame.origin.y =  - offsetY;
    }
    self.topView.frame = frame;
}

@end
