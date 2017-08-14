#import "AppleWatch.h"
#import "WatchConnectivity/WatchConnectivity.h"
#import "CoreFoundation/CoreFoundation.h"

@implementation AppleWatch

// this method is executed when the app loads because of the onload param in plugin.xml
- (void) pluginInitialize {
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

- (void) watchConnection:(NSDictionary *) dict {
  NSLog(@"Watching connection beginz");
  __block CDVPluginResult* pluginResult = nil;
  if(!dict) {
    pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString: @"Some issue no dict"];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dict];
  }
  [self.commandDelegate sendPluginResult:pluginResult];

}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
  
  NSLog(@"Session activation completed with state");
  
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
  // In this case, the message content being sent from the app is a simple begin message. This tells the app to wake up and begin sending location information to the watch.
  [self watchConnection: message];
  NSLog(@"Reached IOS APP %@", message);
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
  NSLog(@"Reached IOS APP");
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
