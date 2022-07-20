//
//  FirstTableView.m
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import "FirstTableView.h"

#define headViewHeight  100

@interface FirstTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FirstTableView

- (void)setTopViewH:(CGFloat)topViewH{
    _topViewH = topViewH;
    
    self.dataSource = self;
    self.delegate = self;
    
    self.scrollIndicatorInsets = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headViewHeight)];
    headerView.backgroundColor = UIColor.systemGreenColor;
    self.tableHeaderView = headerView;
    
    [self registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
}

#pragma mark - UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        self.scrollBlock(scrollView);
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"FirstTableView:第%ld行", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"FirstTableView_didSelectRowAtIndexPathRow:%ld", (long)indexPath.row);
}


@end
