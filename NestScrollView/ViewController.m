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
#import "Masonry.h"

#define isIPhoneXSeries ({\
BOOL iPhoneXSeries = NO;\
if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
(iPhoneXSeries);\
}\
if (@available(iOS 11.0, *)) {\
UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];\
if (mainWindow.safeAreaInsets.bottom > 0.0) {\
iPhoneXSeries = YES;\
}\
}\
(iPhoneXSeries);\
})

/// 状态栏高度
#define kStatusBarHeight  (CGFloat)(isIPhoneXSeries?(44):(20))
/// 状态栏和导航栏总高度
#define kNavBarHeight  (CGFloat)(isIPhoneXSeries?(88):(64))
/// topView的高
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
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    navBar.backgroundColor = UIColor.blueColor;
    navBar.alpha = 0.5;
    [self.view addSubview:navBar];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navBar.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(kTopViewHeight);
    }];
    
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navBar.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - scrollViuew
//父视图滚动的回调，用于横向滚动判断
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%.2f, %.2f",scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    CGFloat placeholderOffset = 0;
    if (self.topView.selectedIndex == 0) {
        if (self.firstTableView.contentOffset.y > CGRectGetHeight(self.topView.frame) - self.topView.itemHeight) {
            placeholderOffset = CGRectGetHeight(self.topView.frame) - self.topView.itemHeight;
        }else {
            placeholderOffset = self.firstTableView.contentOffset.y;
        }
        [self.secondTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }else {
        if (self.secondTableView.contentOffset.y > CGRectGetHeight(self.topView.frame) - self.topView.itemHeight) {
            placeholderOffset = CGRectGetHeight(self.topView.frame) - self.topView.itemHeight;
        }else {
            placeholderOffset = self.secondTableView.contentOffset.y;
        }
        [self.firstTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
}

// 选中第几个tab
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = ceilf(scrollView.contentOffset.x / kScreenWidth);
    self.topView.selectedIndex = index;
}

//子视图滚动的回调，用于竖直方向上滚动判断
- (void)updateTopViewFrame:(UIScrollView *)scrollView{
    CGFloat placeHolderHeight = CGRectGetHeight(self.topView.frame) - self.topView.itemHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat y = 0.0;
    if (offsetY >= 0 && (offsetY <= placeHolderHeight)) {
        NSLog(@"1- offsetY：%.2f <= placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        NSLog(@"2- offsetY：%.2f > placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        y = -placeHolderHeight;
    } else if (offsetY < 0) {
        NSLog(@"3- offsetY：%.2f < 0,  placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        y = -offsetY;
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(y + kNavBarHeight);
    }];
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

//        [self.firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.trailing.bottom.mas_equalTo(scroll);
////            make.edges.mas_equalTo(scroll);
//            make.width.mas_equalTo(kScreenWidth);
////            make.height.mas_equalTo(kScreenHeight);
//        }];
//        [self.secondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(scroll);
////            make.width.mas_equalTo(kScreenWidth);
//            make.height.mas_equalTo(kScreenHeight);
//        }];
        _bottomScrollView = scroll;
    }
    return _bottomScrollView;
}


- (TopView *)topView{
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
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
        _firstTableView = [[FirstTableView alloc] init];
//        _firstTableView = [[FirstTableView alloc] initWithFrame:CGRectZero];
        _firstTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
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
        _secondTableView = [[SecondTableView alloc] init];
//        _secondTableView = [[SecondTableView alloc] initWithFrame:CGRectZero];
        _secondTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
        _secondTableView.topViewH = CGRectGetHeight(self.topView.frame);
        __weak typeof(self) WS = self;
        _secondTableView.scrollBlock = ^(UIScrollView *scrollView) {
            [WS updateTopViewFrame:scrollView];
        };
    }
    return _secondTableView;
}

@end
