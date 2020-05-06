//
//  GLFreePagingLayout.m
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/9.
//  Copyright © 2019 gelei. All rights reserved.
//

#import "GLFreePagingLayout.h"

@implementation GLFreePagingLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.speed = 1.f;
        self.maxInertialCount = NSIntegerMax;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 保证滚动结束后视图的显示效果
    if (self.collectionView.contentOffset.x < 0) {
        [self scrollCenterToIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
        return proposedContentOffset;
    }
    
    if (self.collectionView.contentOffset.x > [super collectionViewContentSize].width - self.collectionView.frame.size.width) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(targetCenterIndexPathForProposedIndexPath:)]) {
            NSInteger count = [self.collectionView numberOfItemsInSection:0];
            [self scrollCenterToIndex:[NSIndexPath indexPathForRow:count - 1 inSection:0]];
        }
        return proposedContentOffset;
    }
    //在speed作用下的proposedContentOffset
    CGFloat tmp = proposedContentOffset.x - self.collectionView.contentOffset.x;
    tmp = tmp * self.speed;
    proposedContentOffset.x = self.collectionView.contentOffset.x + tmp;
    //如果没有开启居中对齐
    if (!self.centerOn) {
        return proposedContentOffset;
    }
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    if (self.pageWidth == 0) {
        self.pageWidth = self.collectionView.frame.size.width;
    }
    CGFloat autoOffset = (self.maxInertialCount - 0.5) * self.pageWidth;
    if (ABS(tmp) > autoOffset) {
        rect = CGRectMake(self.collectionView.contentOffset.x + autoOffset * (tmp > 0 ? 1 : -1), proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    
    // 获得 super 已经计算好的布局的属性
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    
    // 计算 collectionView 最中心点的 x 值
    CGFloat centerX = rect.origin.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    NSIndexPath *indexPath = nil;
    for (UICollectionViewLayoutAttributes *attrs in arr) {
        //cell视图
        if (attrs.representedElementCategory == UICollectionElementCategoryCell && ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
            indexPath = attrs.indexPath;
        }
    }
    [self scrollCenterToIndex:indexPath];
    
    return CGPointMake(rect.origin.x + minDelta, rect.origin.y);
}
//添加滚动动画
- (void)scrollCenterToIndex:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(targetCenterIndexPathForProposedIndexPath:)]) {
        [self.delegate performSelector:@selector(targetCenterIndexPathForProposedIndexPath:) withObject:indexPath];
    }
}

@end
