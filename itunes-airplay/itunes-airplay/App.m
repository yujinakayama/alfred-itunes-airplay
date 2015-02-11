//
//  App.m
//  itunes-airplay
//
//  Created by Yuji Nakayama on 2/11/15.
//  Copyright (c) 2015 Yuji Nakayama. All rights reserved.
//

#import "App.h"

@interface App ()

- (instancetype)initWithArguments:(NSArray*)arguments;
- (NSInteger)run;

@property (nonatomic, readonly) NSArray* arguments;

@end

@implementation App

+ (NSInteger)run
{
    NSArray* arguments = [NSProcessInfo processInfo].arguments;
    App* app = [[self alloc] initWithArguments:arguments];
    return [app run];
}

- (instancetype)initWithArguments:(NSArray*)arguments
{
    self = [super init];

    if (self) {
        _arguments = arguments;
    }

    return self;
}

- (NSInteger)run
{
    if (self.arguments.count < 2) {
        fprintf(stderr, "Specify subcommand.\n");
        return 1;
    }

    NSString* subcommand = self.arguments[1];
    NSLog(@"%@", subcommand);

    return 0;
}

@end
