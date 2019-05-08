//
//  GLFreePagingScrollView.m
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/8.
//  Copyright © 2019 gelei. All rights reserved.
//

#import "GLFreePagingView.h"

@implementation GLFreePagingViewCell

@end

@interface GLFreePagingView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, GLFreePagingViewCell *> *items;
@end

@implementation GLFreePagingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self setupConstraint];
        self.horizontalAlignmentType = GLPagingViewHorizontalAlignmentTypeCenter;
    }
    return self;
}

- (void)setupConstraint{
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:0 toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:0 toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraints:@[top, bottom, left, right]];
}

- (void)didMoveToSuperview {
    [self reloadData];
}

- (UIView *)dequeueReusableCellForIndex:(NSInteger)index {
    return self.items[@(index)];
}

- (void)reloadData {
    NSAssert(self.delegate, @"未设置数据源");
    if (!self.delegate) {
        return;
    }
    NSInteger count = [self.delegate numberOfItemsInPagingView:self];
    CGFloat itemX = self.contentInset.left;
    CGFloat itemY = self.contentInset.top;
    CGFloat interItemSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(interItemSpacingInPagingView:)]) {
        interItemSpacing = [self.delegate interItemSpacingInPagingView:self];
    }
    for (int i = 0; i < count; i++) {
        GLFreePagingViewCell *item = self.items[@(i)];
        if (!item) {
            item = [self.delegate pagingView:self viewForItemAtIndex:i];
            [item addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:item];
            [self.items setObject:item forKey:@(i)];
        }
        CGSize size = [self.delegate pagingView:self sizeForItemAtIndex:i];
        switch (self.horizontalAlignmentType) {
            case GLPagingViewHorizontalAlignmentTypeTop:
                item.frame = CGRectMake(itemX, itemY, size.width, size.height);
                break;
            case GLPagingViewHorizontalAlignmentTypeCenter:
                item.frame = CGRectMake(itemX, (self.frame.size.height - size.height) * 0.5, size.width, size.height);
                break;
            case GLPagingViewHorizontalAlignmentTypeBottom:
                item.frame = CGRectMake(itemX, self.frame.size.height - self.contentInset.bottom - size.height, size.width, size.height);
                break;
            default:
                break;
        }
        itemX += item.frame.size.width + (i == (count - 1) ? self.contentInset.right : interItemSpacing);
    }
    self.scrollView.contentSize = CGSizeMake(itemX, 0);
}

- (void)didSelectedItem:(UIControl *)sender {
    if ([self.delegate respondsToSelector:@selector(pagingView:didSelectItemAtIndex:)]) {
        for (NSNumber *index in self.items.allKeys) {
            if (self.items[index] == sender) {
                [self.delegate pagingView:self didSelectItemAtIndex:index.integerValue];
            }
        }
    }
}

#pragma mark -- UIScrollViewDelegate
//拖动,滑动停止 调用顺序是2->1
//停止拖拽时未滑动 2-->3
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //1
    [self scrollByPaging:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //2
    if (!decelerate) {
        [self scrollByPaging:scrollView];
    }
}

- (void)scrollByPaging:(UIScrollView *)scrollView {
    CGFloat targetX = scrollView.contentOffset.x + scrollView.frame.size.width * 0.5;
    //最近的索引
    NSInteger nearestIndex = 0;
    CGFloat minDistance = fabs(self.items[@(0)].center.x - targetX);
    for (int i = 1; i < self.items.count; i++) {
        CGFloat currentDis = fabs(self.items[@(i)].center.x - targetX);
        if (currentDis > minDistance) {
            break;
        }
        if (currentDis < minDistance) {
            minDistance = currentDis;
            nearestIndex = i;
        }
    }
    CGFloat contentOffsetX = self.items[@(nearestIndex)].center.x - scrollView.frame.size.width * 0.5;
    //左右边界
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    } else if (self.items[@(nearestIndex)].center.x + scrollView.frame.size.width * 0.5 > scrollView.contentSize.width) {
        contentOffsetX = scrollView.contentSize.width - scrollView.frame.size.width;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:NO];
    }];
}

#pragma mark -- Lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.decelerationRate = 0.01;
    }
    return _scrollView;
}

- (NSMutableDictionary<NSNumber *,GLFreePagingViewCell *> *)items {
    if (!_items) {
        _items = [NSMutableDictionary dictionary];
    }
    return _items;
}

@end
