//
//  AlfredResponse.h
//  itunes-airplay
//
//  Created by Yuji Nakayama on 2/11/15.
//  Copyright (c) 2015 Yuji Nakayama. All rights reserved.
//

@import Foundation;

@class iTunesAirPlayDevice;

@interface AlfredResponse : NSObject

+ (instancetype)responseWithAirPlayDevices:(NSArray*)devices;

- (instancetype)initWithAirPlayDevices:(NSArray*)devices;

- (NSString*)XMLString;
- (NSXMLDocument*)XMLDocument;

@end
