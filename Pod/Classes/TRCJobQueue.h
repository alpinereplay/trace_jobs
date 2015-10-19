//
//  TKJobQueue.h
//  TraceKit
//
//  Created by Brian Bal on 1/12/15.
//  Copyright (c) 2015 ActiveReplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRCJob.h"
#import "TRCJobDelegate.h"
#import "TRCJobQueueDelegate.h"

@interface TRCJobQueue : NSObject <TRCJobDelegate>

@property (readwrite) NSUInteger maxConcurrentJobs;
@property (readonly, getter=isPaused) BOOL paused;
@property (assign) id<TRCJobQueueDelegate> delegate;

+ (instancetype)sharedQueue;

+ (void)enqueueJob:(TRCJob *)job;

- (void)addJob:(TRCJob *)job;
- (void)addJobs:(NSArray *)jobs;
- (void)removeJob:(TRCJob *)job;
- (void)clearAllJobs;
- (NSArray *)allJobs;
- (NSArray *)pendingJobs;
- (NSArray *)runningJobs;
- (BOOL)containsJobOfType:(NSUInteger)type;

- (void)pause;
- (void)resume;

@end
