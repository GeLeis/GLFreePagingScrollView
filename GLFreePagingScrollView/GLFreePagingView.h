//
//  GLFreePagingScrollView.h
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/8.
//  Copyright © 2019 gelei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 子视图对齐方式 */
typedef NS_ENUM(NSUInteger, GLPagingViewHorizontalAlignmentType) {
    GLPagingViewHorizontalAlignmentTypeTop,
    GLPagingViewHorizontalAlignmentTypeCenter,
    GLPagingViewHorizontalAlignmentTypeBottom,
};
//子视图
@interface GLFreePagingViewCell : UIControl

@end

@class GLFreePagingView;
@protocol GLFreePagingViewDelegate <NSObject>
@required
- (NSInteger)numberOfItemsInPagingView:(GLFreePagingView *)pagingView;
- (CGSize)pagingView:(GLFreePagingView *)pagingView sizeForItemAtIndex:(NSInteger)index;
- (GLFreePagingViewCell *)pagingView:(GLFreePagingView *)pagingView viewForItemAtIndex:(NSInteger)index;

@optional
- (CGFloat)interItemSpacingInPagingView:(GLFreePagingView *)pagingView;
-(void)pagingView:(GLFreePagingView *)pagingView didSelectItemAtIndex:(NSInteger)index;

@end

@interface GLFreePagingView : UIView
/** 视图周边距 */
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 水平对齐方式 */
@property (nonatomic, assign) GLPagingViewHorizontalAlignmentType horizontalAlignmentType;
@property (nonatomic, weak) id<GLFreePagingViewDelegate> delegate;
- (GLFreePagingViewCell *)dequeueReusableCellForIndex:(NSInteger)index;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
