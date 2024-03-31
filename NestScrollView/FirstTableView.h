//
//  FirstTableView.h
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface FirstTableView : UITableView

@property (assign, nonatomic) CGFloat topViewH;

/// scrollViewDidScroll 回调
@property (nonatomic, copy) void(^scrollBlock)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
