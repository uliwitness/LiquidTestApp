//
//  FUNLiquidCell.h
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

@import Cocoa;

@interface FUNLiquidCell : NSObject

// Persistent:
@property (copy) NSString *colorName;
@property NSInteger weight;
@property BOOL wallMounted;

// Transient/convenience:
@property (strong, readonly) NSColor *color;
@property NSInteger pressureFromLeft;
@property NSInteger pressureFromTop;
@property NSInteger pressureFromRight;
@property NSUInteger lastMovedGeneration;

-(instancetype) initWithPListRepresentation: (NSDictionary*)dict;
-(NSDictionary *)plistRepresentation;

@end
