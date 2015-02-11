//
//  App.m
//  itunes-airplay
//
//  Created by Yuji Nakayama on 2/11/15.
//  Copyright (c) 2015 Yuji Nakayama. All rights reserved.
//

#import "App.h"
#import "iTunes.h"
#import "AlfredResponse.h"

@interface App ()

- (instancetype)initWithArguments:(NSArray*)arguments;
- (NSInteger)run;

@property (nonatomic, readonly) NSArray* arguments;
@property (nonatomic, readonly) iTunesApplication* iTunes;

@end

@implementation App {
    iTunesApplication* _iTunes;
}

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

    if ([subcommand isEqualToString:@"list"]) {
        NSString* query = nil;

        if (self.arguments.count >= 3) {
            query = [self.arguments[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }

        [self listAirPlayDevicesWithQuery:query];
    } else if ([subcommand isEqualToString:@"toggle"]) {
        if (self.arguments.count < 3) {
            fprintf(stderr, "Specify persistent ID of AirPlay device to toggle.\n");
            return 1;
        }

        [self toggleAirPlayDeviceWithPersistentID:self.arguments[2]];
    } else {
        fprintf(stderr, "Unknown subcommand.\n");
        return 1;
    }

    return 0;
}

- (void)listAirPlayDevicesWithQuery:(NSString*)query
{
    NSArray* devices = [self availableAirPlayDevices];

    if (query) {
        NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(iTunesAirPlayDevice* device, NSDictionary* bindings) {
            NSRange range = [device.name.lowercaseString rangeOfString:query];
            return range.location != NSNotFound;
        }];

        devices = [devices filteredArrayUsingPredicate:predicate];
    }

    AlfredResponse* response = [AlfredResponse responseWithAirPlayDevices:devices];

    printf("%s", [[response XMLString] UTF8String]);
}

- (void)toggleAirPlayDeviceWithPersistentID:(NSString*)persistentID
{
    for (iTunesAirPlayDevice* device in [self availableAirPlayDevices]) {
        if ([device.persistentID isEqualToString:persistentID]) {
            device.selected = !device.selected;
            break;
        }
    }
}

- (iTunesApplication*)iTunes
{
    if (!_iTunes) {
        _iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    }

    return _iTunes;
}

- (NSArray*)availableAirPlayDevices
{
    // Convert SBElementArray to NSArray since SBElementArray does not support
    // -[NSArray filteredArrayUsingPredicate:] with NSBlockPredicate.
    NSArray* devices = [self.iTunes.AirPlayDevices get];

    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(iTunesAirPlayDevice* device, NSDictionary* bindings) {
        return device.available;
    }];

    return [devices filteredArrayUsingPredicate:predicate];
}

@end
