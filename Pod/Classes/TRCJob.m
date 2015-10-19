//
//  TKJob.m
//  TraceKit
//
//  Created by Brian Bal on 1/12/15.
//  Copyright (c) 2015 ActiveReplay. All rights reserved.
//

#import "TRCJob.h"

@interface TRCJob ()

@property (nonatomic, strong) NSMutableArray *dependsOn;

@end

@implementation TRCJob

static NSUInteger JobCount = 0;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _jobId = JobCount ++;
        _timeout = -1;
        _priority = TRC_JOB_PRIORITY_NORMAL;
        _callback = nil;
        _delegate = nil;
        _canceled = NO;
        _success = NO;
        _dependsOn = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithPriority:(NSInteger)priority
{
    self = [super init];
    if (self)
    {
        _jobId = JobCount ++;
        _timeout = -1;
        _priority = priority;
        _delegate = nil;
        _callback = nil;
        _canceled = NO;
        _success = NO;
    }
    return self;
}

- (instancetype)initWithPriority:(NSInteger)priority andCallback:(TRCJobCallback)callback
{
    self = [super init];
    if (self)
    {
        _jobId = JobCount ++;
        _timeout = -1;
        _priority = priority;
        _delegate = nil;
        _callback = callback;
        _canceled = NO;
        _success = NO;
    }
    return self;
}

- (void)start
{
    if (_delegate != nil)
    {
        [_delegate jobStarted:self];
    }
    NSString *name = NSStringFromClass([self class]);
    NSLog(@"starting job: %@", name);
    [self run];
}

- (void)run
{
    [self complete:YES withResult:nil];
}

- (void)complete:(BOOL)success withResult:(id)result
{
    NSString *name = NSStringFromClass([self class]);
    if (success)
    {
        NSLog(@"completed job: %@", name);
    }
    else
    {
        NSLog(@"failed job: %@", name);
    }
    
    self.success = success;
    
    if (_callback != nil)
    {
        _callback(success, result);
    }
    if (_delegate != nil)
    {
        [_delegate jobCompleted:self];
    }
}

- (void)cancel
{
    _canceled = YES;
    [self complete:NO withResult:nil];
}

- (BOOL)dependsOnJobWithId:(NSUInteger)jobId
{
    BOOL val = NO;
    for (NSNumber *jid in _dependsOn)
    {
        if (jobId == jid.unsignedIntegerValue)
        {
            val = YES;
            break;
        }
    }
    return val;
}

- (void)setDependsOnJobWithId:(NSUInteger)jobId
{
    [_dependsOn addObject:@(jobId)];
}

@end
