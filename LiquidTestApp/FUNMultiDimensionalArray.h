//
//  FUNMultiDimensionalArray.h
//  GasAndLiquidPhysics
//
//  Created by Uli Kusterer on 03.09.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface FUNMultiDimensionalArray<T> : NSObject

-(instancetype _Nullable) initWithWidth: (NSInteger)width height: (NSInteger)height;
-(instancetype _Nullable) initWithPListRepresentation: (NSDictionary*)serializedMap;

@property NSInteger width;
@property NSInteger height;

-(_Nullable T)	objectAtX: (NSInteger)x y: (NSInteger)y;
-(void)			setObject: (_Nullable T)theObject atX: (NSInteger)x y: (NSInteger)y;
-(void)			objectsSurrounding: (T)theObject atLeft: (_Nonnull T*)outLeft top: (_Nonnull T*)outTop right: (_Nonnull T*)outRight bottom: (_Nonnull T*)outBottom;

-(void)			fillRowRange: (NSRange)rowRange withCopiesOfObject: (_Nullable T)theObject;
-(void)			fillColumnRange: (NSRange)columnRange withCopiesOfObject: (_Nullable T)theObject;

-(NSInteger)	numberOfObjectsMatching: (BOOL(^)(T))filterBlock;
-(void)			forEach: (void(^)(T))filterBlock;

@end

NS_ASSUME_NONNULL_END
