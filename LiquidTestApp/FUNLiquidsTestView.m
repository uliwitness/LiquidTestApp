//
//  FUNLiquidsTestView.m
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "FUNLiquidsTestView.h"


@implementation FUNLiquidsTestView

@synthesize map = _map;

-(instancetype)initWithFrame: (NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		_cellDiameter = 2;
	}
	return self;
}

-(instancetype)initWithCoder: (NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder])
	{
		_cellDiameter = 2;
	}
	return self;
}

- (void)drawRect: (NSRect)dirtyRect
{
//	NSMutableParagraphStyle *centerPStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//	centerPStyle.alignment = NSTextAlignmentCenter;
//	NSDictionary *centerAttrs = @{ NSFontAttributeName: [NSFont systemFontOfSize: 6.0], NSParagraphStyleAttributeName: centerPStyle };
//
//	NSMutableParagraphStyle *leftPStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//	leftPStyle.alignment = NSTextAlignmentLeft;
//	NSDictionary *leftAttrs = @{ NSFontAttributeName: [NSFont systemFontOfSize: 6.0], NSParagraphStyleAttributeName: leftPStyle };
//
//	NSMutableParagraphStyle *rightPStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//	rightPStyle.alignment = NSTextAlignmentRight;
//	NSDictionary *rightAttrs = @{ NSFontAttributeName: [NSFont systemFontOfSize: 6.0], NSParagraphStyleAttributeName: rightPStyle };
	
	@synchronized(self)
	{
		for (NSInteger y = 0; y < _map.height; ++y)
		{
			for (NSInteger x = 0; x < _map.width; ++x)
			{
				FUNLiquidCell *cell = [_map objectAtX: x y: y];
				[cell.color set];
				NSRect box = NSMakeRect(x * _cellDiameter, y * _cellDiameter, _cellDiameter, _cellDiameter);
				NSRectFill(box);
//				if (cell.wallMounted)
//				{
//					[NSColor.blackColor set];
//				}
//				else
//				{
//					[NSColor.lightGrayColor set];
//				}
//
//				[NSBezierPath strokeRect: box];
				
//				NSRect bottomBox = box;
//				bottomBox.origin.y += bottomBox.size.height / 2;
//				bottomBox.size.height /= 2;
//
//				NSString *pressureStr = [NSString stringWithFormat:@"%ld", cell.pressureFromTop];
//				[pressureStr drawInRect: NSInsetRect(box, 2, 2) withAttributes: centerAttrs];
//
//				pressureStr = [NSString stringWithFormat:@"%lu", cell.lastMovedGeneration];
//				[pressureStr drawInRect: NSInsetRect(bottomBox, 2, 2) withAttributes: centerAttrs];
//
//				pressureStr = [NSString stringWithFormat:@"%ld", cell.pressureFromLeft];
//				[pressureStr drawInRect: NSInsetRect(bottomBox, 2, 2) withAttributes: leftAttrs];
//
//				pressureStr = [NSString stringWithFormat:@"%ld", cell.pressureFromRight];
//				[pressureStr drawInRect: NSInsetRect(bottomBox, 2, 2) withAttributes: rightAttrs];
			}
		}
	}
}

-(void)setMap: (FUNMultiDimensionalArray<FUNLiquidCell *> *)map
{
	@synchronized(self)
	{
		_map = map;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self setNeedsDisplay: YES];
	});
}

-(FUNMultiDimensionalArray<FUNLiquidCell *> *)map
{
	@synchronized(self)
	{
		return _map;
	}
}

-(BOOL)isFlipped
{
	return YES;
}

@end
