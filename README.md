# NestScrollView
# scrollview、tableView嵌套解决方案

在网上找了很多，没有喜欢的方案。也参考了众多设计，做了一款自认为比较简洁、完美的方案：

大致思路：外层放置scrollview作为容器，容器内上部分topView，下部分tableView。当tableView滚动时，如果topView还在展示区域，就设置topView的y坐标，让topView跟随同步上移。

（注意：如果不设置tableView的headerView，tableView、和topView都会同时上移不是我想要的效果，所以设置tableView的headerView高度包括topView的高度，达到了完美的效果，具体实现看demo）
## 效果预览：
![NestScrollView](https://user-images.githubusercontent.com/5062917/179965276-de9ad50c-9bb6-43b5-9da4-43f80ae7c7ab.gif)


### 核心代码就是在父视图、子试图的滚动判断
//父视图滚动的回调，用于横向滚动判断
```objectivec
//父视图滚动的回调，用于横向滚动判断
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
```
<br></br>


//子视图滚动的回调，用于竖直方向上滚动判断
```objectivec
//子视图滚动的回调，用于竖直方向上滚动判断
- (void)updateTopViewFrame:(UIScrollView *)scrollView{
    CGFloat placeHolderHeight = CGRectGetHeight(self.topView.frame) - self.topView.itemHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat y = 0.0;
    if (offsetY >= 0 && (offsetY <= placeHolderHeight)) {
        y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        y = -placeHolderHeight;
    } else if (offsetY < 0) {
        y = -offsetY;
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(y + kNavBarHeight);
    }];
}
```
githut demo下载地址：https://github.com/biyuhuaping/NestScrollView
