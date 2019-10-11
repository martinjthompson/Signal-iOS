//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "OWSUnknownProtocolVersionMessage.h"
#import <SignalServiceKit/ContactsManagerProtocol.h>
#import <SignalServiceKit/SSKEnvironment.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

NSUInteger const OWSUnknownProtocolVersionMessageSchemaVersion = 1;

@interface OWSUnknownProtocolVersionMessage ()

@property (nonatomic) NSUInteger protocolVersion;
// If nil, the invalid message was sent by a linked device.
@property (nonatomic, nullable) SignalServiceAddress *sender;
@property (nonatomic, readonly) NSUInteger unknownProtocolVersionMessageSchemaVersion;

@end

#pragma mark -

@implementation OWSUnknownProtocolVersionMessage

- (id<ContactsManagerProtocol>)contactsManager
{
    return SSKEnvironment.shared.contactsManager;
}

- (instancetype)initWithTimestamp:(uint64_t)timestamp
                           thread:(TSThread *)thread
                           sender:(nullable SignalServiceAddress *)sender
                  protocolVersion:(NSUInteger)protocolVersion
{
    self = [super initWithTimestamp:timestamp inThread:thread messageType:TSInfoMessageUnknownProtocolVersion];

    if (self) {
        OWSAssertDebug(sender.isValid);

        _protocolVersion = protocolVersion;
        _sender = sender;
        _unknownProtocolVersionMessageSchemaVersion = OWSUnknownProtocolVersionMessageSchemaVersion;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    if (_unknownProtocolVersionMessageSchemaVersion < 1) {
        NSString *_Nullable phoneNumber = [coder decodeObjectForKey:@"senderId"];
        if (phoneNumber) {
            _sender = [[SignalServiceAddress alloc] initWithPhoneNumber:phoneNumber];
        }
    }

    _unknownProtocolVersionMessageSchemaVersion = OWSUnknownProtocolVersionMessageSchemaVersion;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                    contactShare:(nullable OWSContact *)contactShare
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
                   schemaVersion:(NSUInteger)schemaVersion
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
                   customMessage:(nullable NSString *)customMessage
        infoMessageSchemaVersion:(NSUInteger)infoMessageSchemaVersion
                     messageType:(TSInfoMessageType)messageType
                            read:(BOOL)read
             unregisteredAddress:(nullable SignalServiceAddress *)unregisteredAddress
                 protocolVersion:(NSUInteger)protocolVersion
                          sender:(nullable SignalServiceAddress *)sender
unknownProtocolVersionMessageSchemaVersion:(NSUInteger)unknownProtocolVersionMessageSchemaVersion
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                      contactShare:contactShare
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
                     schemaVersion:schemaVersion
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
                     customMessage:customMessage
          infoMessageSchemaVersion:infoMessageSchemaVersion
                       messageType:messageType
                              read:read
               unregisteredAddress:unregisteredAddress];

    if (!self) {
        return self;
    }

    _protocolVersion = protocolVersion;
    _sender = sender;
    _unknownProtocolVersionMessageSchemaVersion = unknownProtocolVersionMessageSchemaVersion;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    return [self messageTextWithTransaction:transaction];
}

- (NSString *)messageTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    if (!self.sender.isValid) {
        // This was sent from a linked device.
        if (self.isProtocolVersionUnknown) {
            return NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_NEED_TO_UPGRADE_FROM_LINKED_DEVICE",
                @"Info message recorded in conversation history when local user receives an "
                @"unknown message from a linked device and needs to "
                @"upgrade.");
        } else {
            return NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_UPGRADE_COMPLETE_FROM_LINKED_DEVICE",
                @"Info message recorded in conversation history when local user has "
                @"received an unknown unknown message from a linked device and "
                @"has upgraded.");
        }
    }

    NSString *senderName = [self.contactsManager displayNameForAddress:self.sender transaction:transaction];

    if (self.isProtocolVersionUnknown) {
        if (senderName.length > 0) {
            return [NSString
                stringWithFormat:NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_NEED_TO_UPGRADE_WITH_NAME_FORMAT",
                                     @"Info message recorded in conversation history when local user receives an "
                                     @"unknown message and needs to "
                                     @"upgrade. Embeds {{user's name or phone number}}."),
                senderName];
        } else {
            OWSFailDebug(@"Missing sender name.");

            return NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_NEED_TO_UPGRADE_WITHOUT_NAME",
                @"Info message recorded in conversation history when local user receives an unknown message and needs "
                @"to "
                @"upgrade.");
        }
    } else {
        if (senderName.length > 0) {
            return [NSString
                stringWithFormat:NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_UPGRADE_COMPLETE_WITH_NAME_FORMAT",
                                     @"Info message recorded in conversation history when local user has received an "
                                     @"unknown message and has "
                                     @"upgraded. Embeds {{user's name or phone number}}."),
                senderName];
        } else {
            OWSFailDebug(@"Missing sender name.");

            return NSLocalizedString(@"UNKNOWN_PROTOCOL_VERSION_UPGRADE_COMPLETE_WITHOUT_NAME",
                @"Info message recorded in conversation history when local user has received an unknown message and "
                @"has upgraded.");
        }
    }
}

- (BOOL)isProtocolVersionUnknown
{
    return self.protocolVersion > SSKProtos.currentProtocolVersion;
}

@end

NS_ASSUME_NONNULL_END
