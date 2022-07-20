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

///状态栏高度
#define kStatusBarHeight  (CGFloat)(isIPhoneXSeries?(44):(20))
/// 状态栏和导航栏总高度
#define kNavBarHeight  (CGFloat)(isIPhoneXSeries?(88):(64))


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
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    navBar.backgroundColor = UIColor.blueColor;
    navBar.alpha = 0.5;
    [self.view addSubview:navBar];
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
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight);
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
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kTopViewHeight)];
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
        _firstTableView = [[FirstTableView alloc] init];
        _firstTableView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight);
        _firstTableView.itemViweH = kItemheight;
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
        _secondTableView = [[SecondTableView alloc] init];
        _secondTableView.frame = CGRectMake(kScreenWidth, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight);
        _secondTableView.topViewH = CGRectGetHeight(self.topView.frame);
        __weak typeof(self) WS = self;
        _secondTableView.scrollBlock = ^(UIScrollView *scrollView) {
            [WS updateTopViewFrame:scrollView];
        };
    }
    return _secondTableView;
}

- (void)updateTopViewFrame:(UIScrollView *)scrollView{
    CGFloat placeHolderHeight = CGRectGetHeight(self.topView.frame) - kNavBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"offsetY：%.2f, placeHolderHeight：%.2f", offsetY, placeHolderHeight);
    
    CGRect frame = self.topView.frame;
    if (offsetY >= 0 && (offsetY <= placeHolderHeight)) {
        NSLog(@"1- offsetY：%.2f <= placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        frame.origin.y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        NSLog(@"2- offsetY：%.2f > placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        frame.origin.y = - placeHolderHeight;
    } else if (offsetY < 0) {
        NSLog(@"3- offsetY：%.2f < 0,  placeHolderHeight：%.2f", offsetY, placeHolderHeight);
        frame.origin.y =  - offsetY;
    }
    frame.origin.y += kNavBarHeight;
    self.topView.frame = frame;
}

@end
