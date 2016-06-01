//
//  ZCCollectionViewWaterFallLayout.m
//  collectionview自定义
//
//  Created by MS on 16-5-4.
//  Copyright (c) 2016年 ZC. All rights reserved.
//

#import "ZCCollectionViewWaterFallLayout.h"
#import "tgmath.h"

NSString *const ZCCollectionElementKindSectionHeader = @"ZCCollectionElementKindSectionHeader";
NSString *const ZCCollectionElementKindSectionFooter = @"ZCCollectionElementKindSectionFooter";

@interface ZCCollectionViewWaterFallLayout ()

@property (nonatomic,weak)id<ZCCollectionViewDelegateWaterfallLayout>delegate;

@property (nonatomic,strong)NSMutableArray * columnHeights;
@property (nonatomic,strong)NSMutableArray * sectionItemAttributes;
@property (nonatomic,strong)NSMutableArray * allItemAttributes;

@property (nonatomic,strong)NSMutableDictionary * headersAttribute;

@property (nonatomic,strong)NSMutableDictionary * footersAttribute;
#pragma mark -- ??
@property (nonatomic,strong)NSMutableArray * unionRects;


@end

@implementation ZCCollectionViewWaterFallLayout

static const NSInteger unionSize = 20;

static CGFloat ZCFloorCGFloat(CGFloat value){

    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value*scale) / scale;

}

#pragma mark -- public accessors

-(void)setColumnCount:(NSInteger)columnCount{

    if(_columnCount != columnCount){
    
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setMinimumColumnSpacing:(CGFloat)minimumColumnSpacing {
    if (_minimumColumnSpacing != minimumColumnSpacing) {
        _minimumColumnSpacing = minimumColumnSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setHeaderHeight:(CGFloat)headerHeight {
    if (_headerHeight != headerHeight) {
        _headerHeight = headerHeight;
        [self invalidateLayout];
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight {
    if (_footerHeight != footerHeight) {
        _footerHeight = footerHeight;
        [self invalidateLayout];
    }
}

- (void)setHeaderInset:(UIEdgeInsets)headerInset{
    if(!UIEdgeInsetsEqualToEdgeInsets(_headerInset, headerInset)){
    
        _headerInset = headerInset;
        [self invalidateLayout];
        
    }

}

- (void)setFooterInset:(UIEdgeInsets)footerInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_footerInset, footerInset)) {
        _footerInset = footerInset;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

-(void)setItemRenderDirection:(ZCCollectionViewWaterfallLayoutItemRenderDirection)itemRenderDirection{

    if(_itemRenderDirection != itemRenderDirection){
    
        _itemRenderDirection = itemRenderDirection;
        [self invalidateLayout];
    }
}

#pragma mark -- 按组定义列数

-(NSInteger)columnCountForSection:(NSInteger)section{

    if([self.delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]){
    
        return [self.delegate collectionView:self.collectionView layout:self columnCountForSection:section];
    }else{
    
        return self.columnCount;
    }
}


-(CGFloat)itemWidthInSectionAtIndex:(NSInteger)section{
    UIEdgeInsets sectionInset;
    
    if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
    
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }else{
    
        sectionInset = self.sectionInset;
    }
    
    CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
    NSInteger columnCount = [self columnCountForSection:section];
    
    CGFloat columnSpacing = self.minimumColumnSpacing;
    
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]){
    
        columnSpacing = [self.delegate collectionView:self.collectionView layout:self minimumColumnSpacingForSectionAtIndex:section];
    }
    return ZCFloorCGFloat((width - (columnCount -1)*columnSpacing)/columnCount);

}


#pragma mark - Private Accessors
- (NSMutableDictionary *)headersAttribute {
    if (!_headersAttribute) {
        _headersAttribute = [NSMutableDictionary dictionary];
    }
    return _headersAttribute;
}

- (NSMutableDictionary *)footersAttribute {
    if (!_footersAttribute) {
        _footersAttribute = [NSMutableDictionary dictionary];
    }
    return _footersAttribute;
}
#pragma mark -- unionRects
- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (id<ZCCollectionViewDelegateWaterfallLayout>)delegate{

    return (id<ZCCollectionViewDelegateWaterfallLayout>)self.collectionView.delegate
    ;
}

#pragma mark -- init

-(void)commonInit{

    _columnCount = 2;
    _minimumColumnSpacing = 10;
    _minimumInteritemSpacing = 10;
    _headerHeight = 0;
    _footerHeight = 0;
    _sectionInset = UIEdgeInsetsZero;
    _headerInset  = UIEdgeInsetsZero;
    _footerInset  = UIEdgeInsetsZero;
    _itemRenderDirection = ZCCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;

}

-(id)init{

    if(self = [super init]){
    
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}



#pragma mark - Methods to Override
-(void)prepareLayout{
    [self prepareLayout];
    
    [self.headersAttribute removeAllObjects];
    [self.footersAttribute removeAllObjects];
    [self.unionRects removeAllObjects];
    
    [self.columnHeights removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    if(numberOfSections == 0){
        return;
    }
    
    NSAssert([self.delegate conformsToProtocol:@protocol(ZCCollectionViewDelegateWaterfallLayout)],@"UICollectionView,s delegate should confirm to ZCCollectionViewDelegateWaterfallLayout protocol");
    NSAssert(self.columnCount>0||[self.delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)], @"UICollectionViewWaterfallLayout,s columnCount should be greater than 0, or delegate must implement columnCountForSection:");
    

    NSInteger idx = 0;
    
    for(NSInteger section = 0;section < numberOfSections;section++){
    
        NSInteger columCount = [self.collectionView numberOfItemsInSection:section];
        
  //arrayWithCapacity 初始化可变数组的长度
        NSMutableArray * sectionColumnHeights = [NSMutableArray arrayWithCapacity:columCount];
        for(idx = 0;idx < columCount;idx++){
        
            [sectionColumnHeights addObject:@(0)];
            
        }
        [self.columnHeights addObject:sectionColumnHeights];
    }
    
    //creat attributes
    
    CGFloat top = 0;
    
    UICollectionViewLayoutAttributes * attributes;
    
    for(NSInteger section = 0; section < numberOfSections; section++){
    /*
     *1.get section-specific metrics
     (minimumInteritemSpacing, sectionInset)
     */
        
        CGFloat minimumInteritemSpacing;
        
        if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
        
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
            
        }else{
            minimumInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        
        CGFloat columnSpacing = self.minimumColumnSpacing;
        if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]){
        
            columnSpacing = [self.delegate collectionView:self.collectionView layout:self minimumColumnSpacingForSectionAtIndex:section];
            
        }
        
        UIEdgeInsets sectionInset;
        if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
        
            sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            
        }else{
        
            sectionInset = self.sectionInset;
        }
        
        CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
        NSInteger columnCount = [self columnCountForSection:section];
        CGFloat itemWidth = ZCFloorCGFloat((width - (columnCount - 1) * columnSpacing) / columnCount);
        
        
        /*
         *2. Section header
         */
        
        CGFloat headerHeight;
        
        if([self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]){
        
            headerHeight = [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:section];
        }else{
        
            headerHeight = self.headerHeight;
        }
        
        UIEdgeInsets headerInset;
        
        if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForHeaderInSection:)]){
        
            headerInset = [self.delegate collectionView:self.collectionView layout:self insetForHeaderInSection:section];
        }else{
        
            headerInset = self.headerInset;
        }
        
        
        top += sectionInset.top;
        
        for(idx = 0; idx<columnCount; idx++){
        
            self.columnHeights[section][idx] = @(top);
        }
        
        /*
         *3.Section items
         */
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        NSMutableArray * itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        // Item will be put into shortest column.
        
        for(idx = 0;idx<itemCount; idx++){
        
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            
            NSUInteger columnIndex = [self nextColumnIndexForItem:idx inSection:section];
            
            CGFloat xOffset = sectionInset.left + (itemWidth + columnSpacing)*columnIndex;
            CGFloat yOffset = [self.columnHeights[section][columnIndex] floatValue];
            
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            
            CGFloat itemHeight = 0;
            
            if(itemSize.height > 0 && itemSize.width > 0 ){
                itemHeight = ZCFloorCGFloat(itemSize.height * itemWidth / itemSize.width);
            
            }
            
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            
            [self.allItemAttributes addObject:attributes];
            self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + minimumInteritemSpacing);
        }
        
        [self.sectionItemAttributes addObject:itemAttributes];
        
        /*
         * 4. Section footer
         */
        
        CGFloat footerHeight;
        NSUInteger columnIndex = [self longestColumnIndexInSection:section];
        top = [self.columnHeights[section][columnIndex] floatValue] - minimumInteritemSpacing + sectionInset.bottom;
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
            footerHeight = [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:section];
        } else {
            footerHeight = self.footerHeight;
        }
        
        UIEdgeInsets footerInset;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForFooterInSection:)]) {
            footerInset = [self.delegate collectionView:self.collectionView layout:self insetForFooterInSection:section];
        } else {
            footerInset = self.footerInset;
        }
        
        top += footerInset.top;
        
        if (footerHeight > 0) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:ZCCollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(footerInset.left,
                                          top,
                                          self.collectionView.bounds.size.width - (footerInset.left + footerInset.right),
                                          footerHeight);
            
            self.footersAttribute[@(section)] = attributes;
            [self.allItemAttributes addObject:attributes];
            
            top = CGRectGetMaxY(attributes.frame) + footerInset.bottom;
        }
        
        for (idx = 0; idx < columnCount; idx++) {
            self.columnHeights[section][idx] = @(top);
        }
    } // end of for (NSInteger section = 0; section < numberOfSections; ++section)
    
    // Build union rects
    idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
        
        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        
        idx = rectEndIndex;
        
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
        
    }

}

-(CGSize)collectionViewContentSize{
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = [[[self.columnHeights lastObject] firstObject] floatValue];
    
    if (contentSize.height < self.minimumContentHeight) {
        contentSize.height = self.minimumContentHeight;
    }

    
    return contentSize;
}

#pragma mark -- private methods

/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */

-(NSUInteger)shortestColumnIndexSection:(NSInteger)section{

    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if(height < shortestHeight){
        
            shortestHeight = height;
            index = idx;
        }
        
    }];
    
    return index;
}


/**
 *  Find the longest column.
 *
 *  @return index for the longest column
 */

- (NSUInteger)longestColumnIndexInSection:(NSInteger)section {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}



/**
 *  Find the index for the next column.
 *
 *  @return index for the next column
 */
-(NSUInteger)nextColumnIndexForItem:(NSInteger)item inSection:(NSInteger)section{

    NSUInteger index = 0;
    NSInteger columnCount = [self columnCountForSection:section];
    
    switch (self.itemRenderDirection) {
        case ZCCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst:
            index = [self shortestColumnIndexSection:section];
            break;
            
        case ZCCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight:
            index = (item % columnCount);
            break;
        case ZCCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft:
            index = (columnCount - 1) - (item % columnCount);
            break;
            
        default:
            index = [self shortestColumnIndexSection:section];
            break;
    }
    
    return index;
}




@end
