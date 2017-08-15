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

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
  
  NSLog(@"Session activation completed with state");
  
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
  // In this case, the message content being sent from the app is a simple begin message. This tells the app to wake up and begin sending location information to the watch.
  NSLog(@"Reached IOS APP %@", message);
  NSError *error; 
  NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:message 
                                                      options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                        error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSString *toSend     = [NSString stringWithFormat:@"setTimeout(function(){ console.log('cordova avail?', !!cordova); if(!!cordova) { cordova.fireDocumentEvent('cordovaAppleWatch:didReceiveMessage', {data: %@} ) } })", jsonString];
  NSLog(@"JS Method to run %@", toSend);
  [self.commandDelegate evalJs:toSend];
  
}


- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
  NSLog(@"Reached IOS APP");
}



- (void) sendMessage: (CDVInvokedUrlCommand *) command {
    [self.commandDelegate runInBackground:^{
      __block CDVPluginResult* pluginResult = nil;
      NSDictionary *applicationData = [command.arguments objectAtIndex:0];
      if(!applicationData) {
        NSString *error = @"No data send through!";
        NSLog(error);
        pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString: error];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
      } else {
        [[WCSession defaultSession] sendMessage:applicationData
                                  replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                      //handle success
                                      NSLog(@"Successful connection to default session! %@", replyMessage);
                                      pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
                                  } errorHandler:^(NSError * _Nonnull error) {
                                      //handle error
                                      NSLog(@"Houston, we have a problem. %@", error);
                                      pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
                                  }];
      }
      
    
      
    }];
}




@end
