//
//  ZCCollectionViewWaterFallLayout.h
//  collectionview自定义
//
//  Created by MS on 16-5-4.
//  Copyright (c) 2016年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const ZCCollectionElementKindSectionHeader;
extern NSString *const ZCCollectionElementKindSectionFooter;

typedef NS_ENUM(NSInteger, ZCCollectionViewWaterfallLayoutItemRenderDirection) {
    ZCCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst,
    ZCCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight,
    ZCCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft
};


#pragma mark --ZCCollectionViewDelegateWaterfallLayout
@class ZCCollectionViewWaterFallLayout;


@protocol ZCCollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional


- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section;



@end

#pragma mark -- ZCCollectionViewWaterFallLayout

@interface ZCCollectionViewWaterFallLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat minimumColumnSpacing;

//@property (nonatomic,assign) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, assign) UIEdgeInsets headerInset;

@property (nonatomic, assign) UIEdgeInsets footerInset;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) ZCCollectionViewWaterfallLayoutItemRenderDirection itemRenderDirection;
@property (nonatomic, assign) CGFloat minimumContentHeight;

//@property (nonatomic) CGSize itemSize;
//@property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -perferredLayoutAttributesFittingAttributes:
//@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
//@property (nonatomic) CGSize headerReferenceSize;
//@property (nonatomic) CGSize footerReferenceSize;
//@property (nonatomic) UIEdgeInsets sectionInset;


- (CGFloat)itemWidthInSectionAtIndex:(NSInteger)section;




@end
