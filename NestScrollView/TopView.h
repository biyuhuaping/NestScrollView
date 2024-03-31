//
//  TopView.h
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopView : UIView

/// TopView上需要悬停的高度
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) NSInteger selectedIndex;

/// 选择了哪个按钮
@property (copy, nonatomic) void (^block)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
