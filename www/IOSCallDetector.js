var exec = require("cordova/exec");

module.exports = {

    onCall: function(success, error) {

        exec(
            success,
            error,
            "IOSCallDetector",
            "startListening",
            []
        );
    }

};
