//
//  FUNPhysicsController.h
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

@import Foundation;
#import "FUNMultiDimensionalArray.h"
#import "FUNLiquidCell.h"


@interface FUNPhysicsController : NSObject

@property FUNMultiDimensionalArray<FUNLiquidCell *> *map;
@property void(^mapChangedBlock)(FUNMultiDimensionalArray<FUNLiquidCell *> *);

-(void) calculateNextPhysicsFrame;

@end
