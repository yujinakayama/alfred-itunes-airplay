//
//  AlfredResponse.m
//  itunes-airplay
//
//  Created by Yuji Nakayama on 2/11/15.
//  Copyright (c) 2015 Yuji Nakayama. All rights reserved.
//

#import "AlfredResponse.h"
#import "iTunes.h"

@interface AlfredResponse ()

@property (nonatomic, readonly) NSArray* devices;

@end

@implementation AlfredResponse

+ (instancetype)responseWithAirPlayDevices:(NSArray*)devices
{
    return [[self alloc] initWithAirPlayDevices:devices];
}

- (instancetype)initWithAirPlayDevices:(NSArray*)devices
{
    self = [super init];
    if (self) {
        _devices = devices;
    }
    return self;
}

- (NSString*)XMLString
{
    return [[NSString alloc] initWithData:[[self XMLDocument] XMLData] encoding:NSUTF8StringEncoding];
}

- (NSXMLDocument*)XMLDocument
{
    NSXMLElement* itemsElement = [[NSXMLElement alloc] initWithName:@"items"];

    for (iTunesAirPlayDevice* device in self.devices) {
        NSXMLElement* itemElement = [self XMLElementWithDevice:device];
        [itemsElement addChild:itemElement];
    }

    NSXMLDocument* document = [[NSXMLDocument alloc] initWithRootElement:itemsElement];
    document.version = @"1.0";
    document.characterEncoding = @"UTF-8";

    return document;
}

- (NSXMLElement*)XMLElementWithDevice:(iTunesAirPlayDevice*)device
{
    NSXMLElement* itemElement = [[NSXMLElement alloc] initWithName:@"item"];
    [itemElement addAttribute:[NSXMLNode attributeWithName:@"arg" stringValue:device.persistentID]];

    NSString* title = [NSString stringWithFormat:@"%@ speaker “%@”",
                       device.selected ? @"Disable" : @"Enable",
                       device.name];
    [itemElement addChild:[[NSXMLElement alloc] initWithName:@"title" stringValue:title]];

    if (device.selected) {
        NSString* subtitle = [NSString stringWithFormat:@"Sound Volume: %ld", device.soundVolume];
        [itemElement addChild:[[NSXMLElement alloc] initWithName:@"subtitle" stringValue:subtitle]];
    }

    NSXMLElement* iconElement = [[NSXMLElement alloc] initWithName:@"icon" stringValue:@"/Applications/iTunes.app"];
    [iconElement addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"fileicon"]];
    [itemElement addChild:iconElement];

    return itemElement;
}

@end
