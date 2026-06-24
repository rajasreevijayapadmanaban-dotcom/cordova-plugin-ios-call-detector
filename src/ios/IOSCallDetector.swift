import Foundation
import CallKit

@objc(IOSCallDetector)

class IOSCallDetector: CDVPlugin,
                       CXCallObserverDelegate {

    let callObserver = CXCallObserver()

    var callbackId:String?

    @objc(startListening:)

    func startListening(command: CDVInvokedUrlCommand) {

        self.callbackId = command.callbackId

        callObserver.setDelegate(
            self,
            queue: nil
        )

        let result = CDVPluginResult(
            status: CDVCommandStatus_OK
        )

        result?.setKeepCallbackAs(true)

        self.commandDelegate.send(
            result,
            callbackId: command.callbackId
        )
    }

    func callObserver(
        _ callObserver: CXCallObserver,
        callChanged call: CXCall
    ) {

        guard let callbackId = callbackId else {
            return
        }

        var state = "IDLE"

        if call.hasEnded {

            state = "IDLE"

        }
        else if call.isOutgoing {

            state = "OFFHOOK"

        }
        else if !call.hasConnected {

            state = "RINGING"

        }

        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: state
        )

        pluginResult?.setKeepCallbackAs(true)

        self.commandDelegate.send(
            pluginResult,
            callbackId: callbackId
        )
    }
}
