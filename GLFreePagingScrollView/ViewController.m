//
//  ViewController.m
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/8.
//  Copyright © 2019 gelei. All rights reserved.
//

#import "ViewController.h"
#import "GLFreePagingView.h"
#import "GLFreePagingLayout.h"
#define kRandomColor [UIColor colorWithRed:(arc4random()%256)/256.f green:(arc4random()%256)/256.f blue:(arc4random()%256)/256.f alpha:1.0f]
@interface ViewController ()<GLFreePagingViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, GLFreePagingLayoutDelegate>
@property (nonatomic, strong) GLFreePagingView *scrollview;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger proposedIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    _scrollview = [[GLFreePagingView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    _scrollview.backgroundColor = [UIColor greenColor];
    _scrollview.delegate = self;
    _scrollview.horizontalAlignmentType = GLPagingViewHorizontalAlignmentTypeTop;
    [self.view addSubview:_scrollview];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark -- GLFreePagingView
- (NSInteger)numberOfItemsInPagingView:(GLFreePagingView *)pagingView {
    return 20;
}

- (CGSize)pagingView:(GLFreePagingView *)pagingView sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(arc4random_uniform(100) + 50, 200);
}

- (GLFreePagingViewCell *)pagingView:(GLFreePagingView *)pagingView viewForItemAtIndex:(NSInteger)index {
    GLFreePagingViewCell *item = [[GLFreePagingViewCell alloc] init];
    item.backgroundColor = kRandomColor;
    item.layer.cornerRadius = 4;
    item.layer.masksToBounds = YES;
    return item;
}

-(void)pagingView:(GLFreePagingView *)pagingView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%d",index);
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(300, 200);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    return cell;
}

////拖动结束,有速度,开始减速
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    //判断是否需要执行动画
////    if (self.proposedIndex != self.currentIndex) {
//        [self scrollToIndex:[NSIndexPath indexPathForRow:self.proposedIndex inSection:0]];
////    }
//}
//
////人为拖拽,结束拖动
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    //判断是否需要执行动画
////    if (!decelerate && self.proposedIndex != self.currentIndex) {
//        [self scrollToIndex:[NSIndexPath indexPathForRow:self.proposedIndex inSection:0]];
////    }
//}
//
////不是人为拖拽,滚动完毕,这里集中处理
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    if (scrollView.isDragging || scrollView.decelerating || scrollView.tracking) {
//        return;
//    }
//    //滚动滚动结束执行代码
//}
//
////通过代码滚动,将人为滚动转化成代码滚动回调
//- (void)scrollToIndex:(NSIndexPath *)indexpath {
//    self.proposedIndex = indexpath.row;
//    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//}


#pragma mark -- GLFreePagingLayoutDelegate
- (void)targetCenterIndexPathForProposedIndexPath:(NSIndexPath *)indexpath {
    self.proposedIndex = indexpath.row;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:arc4random_uniform(30) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GLFreePagingLayout *layout = [[GLFreePagingLayout alloc] init];
        layout.centerOn = YES;
        layout.speed = 0.3;
        layout.maxInertialCount = 2;
        layout.pageWidth = 300;
        layout.delegate = self;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 200) collectionViewLayout:layout];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
