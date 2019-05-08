//
//  ViewController.m
//  GLFreePagingScrollView
//
//  Created by gelei on 2019/5/8.
//  Copyright © 2019 gelei. All rights reserved.
//

#import "ViewController.h"
#import "GLFreePagingView.h"
#define kRandomColor [UIColor colorWithRed:(arc4random()%256)/256.f green:(arc4random()%256)/256.f blue:(arc4random()%256)/256.f alpha:1.0f]
@interface ViewController ()<GLFreePagingViewDelegate>
@property (nonatomic, strong) GLFreePagingView *scrollview;
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
}

#pragma mark -- GLFreePagingView
- (NSInteger)numberOfItemsInPagingView:(GLFreePagingView *)pagingView {
    return 15;
}

- (CGSize)pagingView:(GLFreePagingView *)pagingView sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(200, arc4random_uniform(100) + 50);
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
@end
