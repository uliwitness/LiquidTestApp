//
//  FUNLiquidCell.m
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "FUNLiquidCell.h"


@interface FUNLiquidCell ()

@property (strong, readwrite) NSColor *color;

@end


@implementation FUNLiquidCell

-(instancetype) initWithPListRepresentation: (NSDictionary*)dict
{
	if (self = [super init])
	{
		_colorName = dict[@"color"];
		_color = [NSColor performSelector:NSSelectorFromString([_colorName stringByAppendingString: @"Color"]) withObject:nil];
		_weight = [dict[@"weight"] integerValue];
		_wallMounted = [dict[@"wallMounted"] boolValue];
	}
	return self;
}

-(NSDictionary *)plistRepresentation
{
	return @{ @"class": self.className, @"color": _colorName, @"weight": @(_weight), @"wallMounted": @(_wallMounted) };
}

@end
