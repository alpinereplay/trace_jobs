//
//  TKJobQueue.m
//  TraceKit
//
//  Created by Brian Bal on 1/12/15.
//  Copyright (c) 2015 ActiveReplay. All rights reserved.
//

#import "TRCJobQueue.h"

@interface TRCJobQueue ()

@property (nonatomic, strong) NSMutableArray *runningJobs;
@property (nonatomic, strong) NSMutableArray *pendingJobs;

@end

@implementation TRCJobQueue

+ (instancetype)sharedQueue
{
    static TRCJobQueue *sharedQueue = nil;
    @synchronized(self) {
        if (sharedQueue == nil)
            sharedQueue = [[self alloc] init];
    }
    return sharedQueue;
}

+ (void)enqueueJob:(TRCJob *)job
{
    [[self sharedQueue] addJob:job];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _paused = NO;
        _maxConcurrentJobs = 1;
        _runningJobs = [[NSMutableArray alloc] initWithCapacity:2];
        _pendingJobs = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)pause
{
    _paused = YES;
}

- (void)resume
{
    if (_paused)
    {
        _paused = NO;
        [self processJobs];
    }
}

- (void)addJob:(TRCJob *)job
{
    job.delegate = self;
    [_pendingJobs addObject:job];
    [_pendingJobs sortUsingComparator:^NSComparisonResult(TRCJob *obj1, TRCJob *obj2) {
        NSComparisonResult result = [@(100 - obj1.priority) compare:@(100 - obj2.priority)];
        if (result == NSOrderedSame)
        {
            result = [@(obj1.jobId) compare:@(obj2.jobId)];
        }
        return result;
    }];
    [self processJobs];
}

- (void)addJobs:(NSArray *)jobs
{
    for (TRCJob *job in jobs)
    {
        job.delegate = self;
        [_pendingJobs addObject:job];
    }
    [_pendingJobs sortUsingComparator:^NSComparisonResult(TRCJob *obj1, TRCJob *obj2) {
        NSComparisonResult result = [@(100 - obj1.priority) compare:@(100 - obj2.priority)];
        if (result == NSOrderedSame)
        {
            result = [@(obj1.jobId) compare:@(obj2.jobId)];
        }
        return result;
    }];
    [self processJobs];
}

- (void)removeJob:(TRCJob *)job
{
    [_pendingJobs removeObject:job];
    [self checkForAllJobsCompleted];
}

- (void)clearAllJobs
{
    [_pendingJobs removeAllObjects];
}

- (void)jobStarted:(TRCJob *)job
{
    
}

- (void)jobCompleted:(TRCJob *)job
{
    [_runningJobs removeObject:job];
    if (!job.success)
    {
        NSMutableArray *jobsToCancel = [[NSMutableArray alloc] init];
        for (TRCJob *j in _pendingJobs)
        {
            if ([j dependsOnJobWithId:job.jobId])
            {
                [jobsToCancel addObject:j];
            }
        }
        [_pendingJobs removeObjectsInArray:jobsToCancel];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(jobQueue:didCompletedJob:)])
    {
        [_delegate jobQueue:self didCompletedJob:job];
    }
    [self processJobs];
}

- (void)processJobs
{
    @synchronized(self)
    {
        if (!_paused && [_runningJobs count] < _maxConcurrentJobs && [_pendingJobs count] > 0)
        {
            TRCJob *job = [_pendingJobs firstObject];
            if (job != nil)
            {
                [_runningJobs addObject:job];
                [_pendingJobs removeObject:job];
                
                if (_delegate != nil && [_delegate respondsToSelector:@selector(jobQueue:willStartJob:)])
                {
                    [_delegate jobQueue:self willStartJob:job];
                }
                [job start];
            }
        }
        else
        {
            [self checkForAllJobsCompleted];
        }
    }
}

- (void)checkForAllJobsCompleted
{
    if (_runningJobs.count == 0 && _pendingJobs.count == 0)
    {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(jobQueueCompletedAllJobs:)])
        {
            [_delegate jobQueueCompletedAllJobs:self];
        }
    }
}

- (BOOL)containsJobOfType:(NSUInteger)type
{
    NSArray *allJobs = [self allJobs];
    BOOL val = NO;
    for (TRCJob *job in allJobs)
    {
        if (job.jobType == type)
        {
            val = YES;
            break;
        }
    }
    return val;
}

- (NSArray *)allJobs
{
    NSMutableArray *allJobs = [[NSMutableArray alloc] initWithArray:_runningJobs];
    [allJobs addObjectsFromArray:_pendingJobs];
    return [NSArray arrayWithArray:allJobs];
}

- (NSArray *)pendingJobs
{
    return [NSArray arrayWithArray:_pendingJobs];
}

- (NSArray *)runningJobs
{
    return [NSArray arrayWithArray:_runningJobs];
}

@end
