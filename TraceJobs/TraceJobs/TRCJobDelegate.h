//
//  TKJobDelegate.h
//  TraceKit
//
//  Created by Brian Bal on 1/12/15.
//  Copyright (c) 2015 ActiveReplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRCJob;

@protocol TRCJobDelegate <NSObject>

- (void)jobStarted:(TRCJob *)job;
- (void)jobCompleted:(TRCJob *)job;

@end