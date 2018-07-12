//
//  FUNPhysicsController.m
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "FUNPhysicsController.h"


@interface FUNCellRange : NSObject

@property NSMutableIndexSet *sourceIndexes;
@property NSMutableIndexSet *targetIndexes;

@end


@interface FUNPhysicsController ()
{
	NSUInteger _currentGeneration;
}

@end


@implementation FUNPhysicsController

-(void) calculateNextPhysicsFrame
{
	++_currentGeneration;
	
	// Calculate pressure on each cell, so cells can flow sideways
	//	in an intuitively "right" direction:
	for (NSInteger y = 0; y < _map.height; ++y)
	{
		for (NSInteger x = 0; x < _map.width; ++x)
		{
			FUNLiquidCell *cell = [_map objectAtX: x y: y];
			if (y > 0) {
				FUNLiquidCell *topCell = [_map objectAtX: x y: y - 1];
				
				if (!topCell.wallMounted)
				{
					cell.pressureFromTop = topCell.pressureFromTop + topCell.weight;
				}
				else
				{
					cell.pressureFromTop = 0;
				}
			}
			else
			{
				cell.pressureFromTop = 0;
			}
		}
	}
	
	for (NSInteger x = 0; x < _map.width; ++x)
	{
		for (NSInteger y = 0; y < _map.height; ++y)
		{
			FUNLiquidCell *cell = [_map objectAtX: x y: y];
			if (x > 0) {
				FUNLiquidCell *leftCell = [_map objectAtX: x - 1 y: y];
				
				if (!leftCell.wallMounted)
				{
					cell.pressureFromLeft = leftCell.pressureFromLeft + leftCell.weight;
				}
				else
				{
					cell.pressureFromLeft = 0;
				}
			}
			else
			{
				cell.pressureFromLeft = 0;
			}
		}
	}
	
	for (NSInteger x = _map.width -1; x >= 0; --x)
	{
		for (NSInteger y = 0; y < _map.height; ++y)
		{
			FUNLiquidCell *cell = [_map objectAtX: x y: y];
			if (x < (_map.width -1)) {
				FUNLiquidCell *rightCell = [_map objectAtX: x + 1 y: y];
				
				if (!rightCell.wallMounted)
				{
					cell.pressureFromRight = rightCell.pressureFromRight + rightCell.weight;
				}
				else
				{
					cell.pressureFromRight = 0;
				}
			}
			else
			{
				cell.pressureFromRight = 0;
			}
		}
	}
	
	// Now apply "gravity" heuristic:
	for (NSInteger y = 0; y < _map.height; ++y)
	{
		for (NSInteger x = 0; x < _map.width; ++x)
		{
			// If a heavier cell is above a lighter one, drop it down by swapping the two:
			FUNLiquidCell *cell = [_map objectAtX: x y: y];
			FUNLiquidCell *belowCell = nil;
			BOOL alreadySwappedOne = NO;
			
			if (y < (_map.height - 1)) {
				belowCell = [_map objectAtX: x y: y + 1];
				
				if (!cell.wallMounted && !belowCell.wallMounted && belowCell.weight < cell.weight
					&& cell.lastMovedGeneration != _currentGeneration && belowCell.lastMovedGeneration != _currentGeneration)
				{
					[_map setObject: cell atX: x y: y + 1];
					[_map setObject: belowCell atX: x y: y];
					cell.lastMovedGeneration = _currentGeneration;
					belowCell.lastMovedGeneration = _currentGeneration;
					alreadySwappedOne = YES;
				}
			}
			
			// Can't drop below? Check if it makes sense to flow sideways:
			BOOL needToAvoidBelow = (belowCell == nil) || belowCell.wallMounted || belowCell.weight == cell.weight;
			
			// Flow right?
			if (!alreadySwappedOne && x < (_map.width - 1))
			{
				FUNLiquidCell *rightCell = [_map objectAtX: x + 1 y: y];
				if (!cell.wallMounted && !rightCell.wallMounted
					&& (needToAvoidBelow || cell.pressureFromLeft > cell.pressureFromRight)
					&& rightCell.weight < cell.weight
					&& cell.lastMovedGeneration != _currentGeneration && rightCell.lastMovedGeneration != _currentGeneration) {
					[_map setObject: cell atX: x + 1 y: y];
					[_map setObject: rightCell atX: x y: y];
					cell.lastMovedGeneration = _currentGeneration;
					rightCell.lastMovedGeneration = _currentGeneration;
					alreadySwappedOne = YES;
				}
			}
			
			// Flow left:
			if (!alreadySwappedOne && x > 0)
			{
				FUNLiquidCell *leftCell = [_map objectAtX: x - 1 y: y];
				if (!cell.wallMounted && !leftCell.wallMounted
					&& (needToAvoidBelow || cell.pressureFromRight > cell.pressureFromLeft)
					&& leftCell.weight < cell.weight
					&& cell.lastMovedGeneration != _currentGeneration && leftCell.lastMovedGeneration != _currentGeneration) {
					[_map setObject: cell atX: x - 1 y: y];
					[_map setObject: leftCell atX: x y: y];
					cell.lastMovedGeneration = _currentGeneration;
					leftCell.lastMovedGeneration = _currentGeneration;
					alreadySwappedOne = YES;
				}
			}
		}
	}

	// If there's a cell sitting atop a range of cells of the same type,
	//	and the range has an "empty" spot before or after it, swap that
	//	top cell and the empty range, as if the lighter liquid had "bubbled
	//	up" through the range.
	for (NSInteger y = (_map.height -1); y > 0; --y)
	{
		// Collect ranges of same weight on top of current row that are candidates for pulling down:
		NSMutableArray<FUNCellRange *> *ranges = [NSMutableArray new];
		FUNLiquidCell *prevCell = nil;
		FUNCellRange *currRange = [FUNCellRange new];
		[ranges addObject: currRange];
		
		for (NSInteger x = 0; x < _map.width; ++x)
		{
			FUNLiquidCell *cell = [_map objectAtX: x y: y];
			FUNLiquidCell *aboveCell = [_map objectAtX: x y: y - 1];

			if ((prevCell && prevCell.weight != cell.weight) || cell.wallMounted)
			{
				if (prevCell && !cell.wallMounted && prevCell.weight > cell.weight)
				{
					[currRange.targetIndexes addIndex: x];
				}

				currRange = [FUNCellRange new];

				if (prevCell && !cell.wallMounted && prevCell.weight < cell.weight)
				{
					[currRange.targetIndexes addIndex: x - 1];
				}
				
				[ranges addObject: currRange];
			}

			if (aboveCell.weight == cell.weight && !aboveCell.wallMounted && !cell.wallMounted)
			{
				[currRange.sourceIndexes addIndex: x];
			}
			
			prevCell = cell;
		}
		
		for (FUNCellRange * currRange in ranges)
		{
			NSInteger targetIndex = currRange.targetIndexes.firstIndex;
			NSInteger sourceIndex = currRange.sourceIndexes.firstIndex;
			while (targetIndex != NSNotFound && sourceIndex != NSNotFound)
			{
				FUNLiquidCell *targetCell = [_map objectAtX: targetIndex y: y];
				FUNLiquidCell *sourceCell = [_map objectAtX: sourceIndex y: y - 1];

				[_map setObject: sourceCell atX:targetIndex y: y];
				[_map setObject: targetCell atX:sourceIndex y: y -1];

				targetIndex = [currRange.targetIndexes indexGreaterThanIndex: targetIndex];
				sourceIndex = [currRange.sourceIndexes indexGreaterThanIndex: sourceIndex];
			}
		}
	}
	_mapChangedBlock(_map);
}

@end


@implementation FUNCellRange

-(instancetype)	init
{
	if (self = [super init])
	{
		_sourceIndexes = [NSMutableIndexSet new];
		_targetIndexes = [NSMutableIndexSet new];
	}
	return self;
}

@end

