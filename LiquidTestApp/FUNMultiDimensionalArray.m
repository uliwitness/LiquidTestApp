//
//  FUNMultiDimensionalArray.m
//  GasAndLiquidPhysics
//
//  Created by Uli Kusterer on 03.09.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "FUNMultiDimensionalArray.h"


id FUNNSNullToNil( id inValue )
{
	return (inValue == [NSNull null]) ? nil : inValue;
}


@interface FUNMultiDimensionalArray ()

@property NSMutableArray * arrayData;

@end


@implementation FUNMultiDimensionalArray

-(id) initWithWidth: (NSInteger)width height: (NSInteger)height
{
	NSInteger count = width * height;
	self = [super init];
	if( !self ) return nil;

	_arrayData = [NSMutableArray array];
	for( NSInteger x = 0; x < count; ++x )
	{
		[_arrayData addObject: [NSNull null]];
	}
	_width = width;
	_height = height;

	return self;
}


-(instancetype _Nullable) initWithPListRepresentation: (NSDictionary*)serializedMap
{
	self = [super init];
	if( !self ) return nil;
	
	_width = [serializedMap[@"width"] integerValue];
	_height = [serializedMap[@"height"] integerValue];
	
	_arrayData = [NSMutableArray array];
	for( NSArray * currentRow in serializedMap[@"rows"] )
	{
		NSInteger cellsToGo = _width;
		for( NSDictionary * currentCell in currentRow )
		{
			id theCell = nil;
			NSString * className = currentCell[@"class"];
			if( className )
			{
				Class cellClass = NSClassFromString(className);
				theCell = [[cellClass alloc] initWithPListRepresentation: currentCell];
			}
			else
				theCell = [NSNull null];
			[_arrayData addObject: theCell];
			--cellsToGo;
		}
		
		while( (--cellsToGo) >= 0 )
		{
			[_arrayData addObject: [NSNull null]];
		}
	}

	return self;
}


-(_Nullable id) objectAtX: (NSInteger)x y: (NSInteger)y
{
	id theObject = [_arrayData objectAtIndex: (_width * y) + x];
	if( theObject == [NSNull null] )
		return nil;
	return theObject;
}


-(void) setObject: (_Nullable id)theObject atX: (NSInteger)x y: (NSInteger)y
{
	if( !theObject )
		theObject = [NSNull null];
	[_arrayData replaceObjectAtIndex: (_width * y) + x withObject: theObject];
}


-(void)	objectsSurrounding: (id)theObject atLeft: (id*)outLeft top: (id*)outTop right: (id*)outRight bottom: (id*)outBottom
{
	NSInteger objectIndex = [_arrayData indexOfObject: theObject];

	*outLeft = nil;
	*outTop = nil;
	*outRight = nil;
	*outBottom = nil;

	if( objectIndex == NSNotFound ) return;

	if( (objectIndex % _width) > 0 ) *outLeft = FUNNSNullToNil(_arrayData[objectIndex -1]);
	if( (objectIndex % _width) < (_width -1) ) *outRight = FUNNSNullToNil( _arrayData[objectIndex +1] );
	if( objectIndex >= _width ) *outTop = FUNNSNullToNil( _arrayData[objectIndex -_width] );
	if( objectIndex < (_arrayData.count -_width) ) *outBottom = FUNNSNullToNil( _arrayData[objectIndex +_width] );
}


-(void)			fillRowRange: (NSRange)rowRange withCopiesOfObject: (_Nullable id)theObject
{
	NSInteger startIndex = _width * rowRange.location;
	NSInteger endIndex = _width * (rowRange.location + rowRange.length);
	for( NSInteger x = startIndex; x < endIndex; ++x )
	{
		[_arrayData replaceObjectAtIndex: x withObject: [theObject copy]];
	}
}


-(void)			fillColumnRange: (NSRange)columnRange withCopiesOfObject: (_Nullable id)theObject
{
	NSInteger columnStartIndex = columnRange.location;
	NSInteger columnEndIndex = columnRange.location + columnRange.length;
	for( NSInteger y = 0; y < _height; ++y )
	{
		for( NSInteger x = columnStartIndex; x < columnEndIndex; ++x )
		{
			[_arrayData replaceObjectAtIndex: x withObject: [theObject copy]];
		}
		columnStartIndex += _width;
		columnEndIndex += _width;
	}
}


-(NSInteger) numberOfObjectsMatching: (BOOL(^)(id))filterBlock
{
	NSInteger count = 0;
	for( id obj in _arrayData )
	{
		if( filterBlock(obj) ) ++count;
	}
	return count;
}


-(void)	forEach: (void(^)(id))filterBlock
{
	for( id obj in _arrayData )
	{
		if( obj != [NSNull null] )
			filterBlock(obj);
	}
}

@end
