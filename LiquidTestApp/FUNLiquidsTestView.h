//
//  FUNLiquidsTestView.h
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

@import Cocoa;
#import "FUNMultiDimensionalArray.h"
#import "FUNLiquidCell.h"


@interface FUNLiquidsTestView : NSView

@property IBInspectable CGFloat cellDiameter;
@property (strong) FUNMultiDimensionalArray<FUNLiquidCell *> *map;

@end
