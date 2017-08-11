#import "AppleWatch.h"
#import "WatchConnectivity/WatchConnectivity.h"

@implementation AppleWatch

// this method is executed when the app loads because of the onload param in plugin.xml
- (void)pluginInitialize {
    NSLog(@"Initializing Apple Watch plugin!");
}

- (void) initializeSession: (CDVInvokedUrlCommand *) command {
    [self.commandDelegate runInBackground:^{
        __block CDVPluginResult* pluginResult = nil;
        if ([WCSession isSupported]) {
          NSLog(@"WC Session is supported! Sweet.");
          WCSession* session = [WCSession defaultSession];
          session.delegate = self;
          [session activateSession];
          pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsBool: true];
          [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
        } else {
          pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsBool: false];
          [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
        } 
    }];
}

- (void) sendMessage: (CDVInvokedUrlCommand *) command {
    [self.commandDelegate runInBackground:^{

      NSString *teststring = [NSString stringWithFormat:@"%s", "Hello World"];
      NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[teststring] forKeys:@[@"testdata"]];
      __block CDVPluginResult* pluginResult = nil;
    
      [[WCSession defaultSession] sendMessage:applicationData
                                  replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                      //handle success
                                      NSLog(@"Successful connection to default session! %@", replyMessage);
                                      pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsBool: true];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
                                  } errorHandler:^(NSError * _Nonnull error) {
                                      //handle error
                                      NSLog(@"Houston, we have a problem. %@", error);
                                      pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsBool: false];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
                                  }];
    }];
}




@end
