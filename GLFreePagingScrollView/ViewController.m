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
@interface ViewController ()<GLFreePagingViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) GLFreePagingView *scrollview;
@property (nonatomic, strong) UICollectionView *collectionView;
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
    return 15;
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
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 200);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GLFreePagingLayout *layout = [[GLFreePagingLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 200) collectionViewLayout:layout];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return _collectionView;
}

@end
