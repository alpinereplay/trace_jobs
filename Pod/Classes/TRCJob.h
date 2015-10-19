//
//  TKJob.h
//  TraceKit
//
//  Created by Brian Bal on 1/12/15.
//  Copyright (c) 2015 ActiveReplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRCJobDelegate.h"

#define TRC_JOB_PRIORITY_HIGHEST 100
#define TRC_JOB_PRIORITY_HIGH 3
#define TRC_JOB_PRIORITY_NORMAL 2
#define TRC_JOB_PRIORITY_LOW 1

typedef void (^TRCJobCallback)(BOOL success, id result);

@interface TRCJob : NSObject

@property (readonly) NSUInteger jobId;
@property (readwrite) NSUInteger priority;
@property (readwrite) NSInteger timeout;
@property (readwrite) NSUInteger jobType;
@property (readwrite) NSUInteger jobCategory;
@property (readwrite) BOOL success;
@property (readonly) BOOL canceled;
@property (nonatomic, copy) TRCJobCallback callback;
@property (assign) id<TRCJobDelegate> delegate;

- (instancetype)initWithPriority:(NSInteger)priority;
- (void)start;
- (void)run;
- (void)complete:(BOOL)success withResult:(id)result;
- (void)cancel;

- (BOOL)dependsOnJobWithId:(NSUInteger)jobId;
- (void)setDependsOnJobWithId:(NSUInteger)jobId;

@end
