#import "IOSCallDetector.h"

@implementation IOSCallDetector

- (void)pluginInitialize {

    self.callObserver = [[CXCallObserver alloc] init];

}

- (void)startListening:(CDVInvokedUrlCommand*)command {

    self.callbackId = command.callbackId;

    [self.callObserver setDelegate:self queue:nil];

    CDVPluginResult *result =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [result setKeepCallbackAsBool:YES];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

- (void)callObserver:(CXCallObserver *)callObserver
         callChanged:(CXCall *)call {

    if (!self.callbackId) {
        return;
    }

    NSString *state = @"IDLE";

    if (call.hasEnded) {

        state = @"IDLE";

    } else if (call.isOutgoing) {

        state = @"OFFHOOK";

    } else if (!call.hasConnected) {

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
