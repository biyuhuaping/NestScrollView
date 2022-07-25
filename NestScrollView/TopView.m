//
//  TopView.m
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import "TopView.h"

#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

@interface TopView ()

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

@end

@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = UIColor.lightGrayColor;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, self.frame.size.height - self.itemHeight, kScreenWidth /2, self.itemHeight);
    [leftBtn setTitle:@"FirstItem" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor whiteColor];
    leftBtn.layer.borderWidth = 0.5;
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 0;
    [self addSubview:leftBtn];
    _leftBtn = leftBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(kScreenWidth /2, self.frame.size.height - self.itemHeight, kScreenWidth /2, self.itemHeight);
    [rightBtn setTitle:@"SecondItem" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.layer.borderWidth = 0.5;
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 1;
    [self addSubview:rightBtn];
    _rightBtn = rightBtn;    
}

- (CGFloat)itemHeight{
    return 50;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (selectedIndex == 0) {
        [_leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else {
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)buttonAction:(UIButton *)sender{
    if (self.block) {
        self.block(sender.tag);
    }
}

@end
