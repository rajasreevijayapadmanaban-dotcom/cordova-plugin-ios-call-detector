#import <Cordova/CDV.h>
#import <CallKit/CallKit.h>

@interface IOSCallDetector : CDVPlugin <CXCallObserverDelegate>

@property (nonatomic, strong) CXCallObserver *callObserver;
@property (nonatomic, strong) NSString *callbackId;

- (void)startListening:(CDVInvokedUrlCommand*)command;

@end


@implementation IOSCallDetector

- (void)startListening:(CDVInvokedUrlCommand*)command {

    self.callbackId = command.callbackId;

    self.callObserver = [[CXCallObserver alloc] init];
    self.callObserver.delegate = self;

    CDVPluginResult *result =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [result setKeepCallbackAsBool:YES];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}


// iOS CallKit callback
- (void)callObserver:(CXCallObserver *)callObserver
     callChanged:(CXCall *)call {

    NSString *state = @"IDLE";

    if (call.hasEnded) {
        state = @"IDLE";
    }
    else if (call.isOutgoing) {
        state = @"OFFHOOK";
    }
    else if (!call.hasConnected) {
        state = @"RINGING";
    }

    CDVPluginResult *pluginResult =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                          messageAsString:state];

    [pluginResult setKeepCallbackAsBool:YES];

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:self.callbackId];
}

@end
