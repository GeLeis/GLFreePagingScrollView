//
//  GLFreePagingLayout.h
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/9.
//  Copyright © 2019 gelei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLFreePagingLayoutDelegate <NSObject>
- (void)targetCenterIndexPathForProposedIndexPath:(NSIndexPath *)indexpath;
@end

@interface GLFreePagingLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<GLFreePagingLayoutDelegate> delegate;
/** speed 0~1.f,惯性大小,默认为1 */
@property (nonatomic, assign) CGFloat speed;
/** 居中对其 */
@property (nonatomic, assign) BOOL centerOn;
/** 开启居中对齐,在惯性作用下,松手后最大允许滑动的page数,可同时和speed作用,默认maxInertialCount为MAX */
@property (nonatomic, assign) NSInteger maxInertialCount;
/**
 分页的宽度pageWidth,
 1.在居中对齐情况下,如果依赖惯性滑动的距离>pageWidth * 0.5,那么就选择下一个cell对齐
 2.默认pageWidth为collectionView的Width
 */
@property (nonatomic, assign) CGFloat pageWidth;
@end

NS_ASSUME_NONNULL_END
