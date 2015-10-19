//
//  TKJobQueueDelegate.h
//  TraceKit
//
//  Created by Brian Bal on 2/26/15.
//  Copyright (c) 2015 AlpineReplay. All rights reserved.
//

@class TRCJobQueue;
@class TRCJob;

@protocol TRCJobQueueDelegate <NSObject>

@optional
- (void)jobQueue:(TRCJobQueue *)jobQueue willStartJob:(TRCJob *)job;
- (void)jobQueue:(TRCJobQueue *)jobQueue didCompletedJob:(TRCJob *)job;
- (void)jobQueueCompletedAllJobs:(TRCJobQueue *)jobQueue;

@end
