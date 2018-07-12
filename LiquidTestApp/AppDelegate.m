//
//  AppDelegate.m
//  LiquidTestApp
//
//  Created by Uli Kusterer on 11.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "AppDelegate.h"
#import "FUNLiquidsTestView.h"
#import "FUNMultiDimensionalArray.h"
#import "FUNPhysicsController.h"


void *kAppDelegateMapKVOContext = &kAppDelegateMapKVOContext;


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet FUNLiquidsTestView *mapView;
@property (strong) FUNPhysicsController *physicsController;
@property (strong) NSTimer *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL: [NSBundle.mainBundle URLForResource: @"map" withExtension: @"plist"]];
	FUNMultiDimensionalArray *map = [[FUNMultiDimensionalArray alloc] initWithPListRepresentation: dict];
	_mapView.map = map;
	
	FUNLiquidsTestView *mapView = _mapView;
	_physicsController = [FUNPhysicsController new];
	_physicsController.map = map;
	_physicsController.mapChangedBlock = ^(FUNMultiDimensionalArray<FUNLiquidCell *> *inMap)
	{
		mapView.map = inMap;
		[mapView.window display];
	};
}

-(IBAction)	resetPhysicsSimulation:(nullable id)sender
{
	[_timer invalidate];
	_timer = nil;

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL: [NSBundle.mainBundle URLForResource: @"map" withExtension: @"plist"]];
	FUNMultiDimensionalArray *map = [[FUNMultiDimensionalArray alloc] initWithPListRepresentation: dict];
	_mapView.map = map;
	_physicsController.map = map;
}

-(IBAction) runPhysicsFrames: (nullable id)sender
{
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval: 0.05 repeats: YES block:^(NSTimer * _Nonnull timer)
	 {
		 [self->_physicsController calculateNextPhysicsFrame];
	 }];
}

-(IBAction) nextPhysicsFrame: (nullable id)sender
{
	[_timer invalidate];
	_timer = nil;

	[self->_physicsController calculateNextPhysicsFrame];
}

@end
