---
Title: Apple Watch Plugin
Description: Connect to Apple Watch via Watch Connectivity framework and send/receive messages.
---

Installation
-------------------

```javascript
cordova plugin add https://github.com/thessler27/watch-plugin.git
```

Utilization
-------------------

_You must initialize the session for the Apple Watch listener to be activated and to send messages._

### Initialize 

```javascript
AppleWatch.initializeSession():Promise<boolean>
```

> Returns successful promise result with `true` boolean if successful connection, and throws an error with boolean `false` if unsuccessful.

### Watch for incoming messages

```javascript
document.addEventListener('cordovaAppleWatch:didReceiveMessage', handleWatchEventWithData)
```

> When the watch sends a message to the iOS device, it sends the data through this event.

### Send a message to the watch listener

```javascript
AppleWatch.sendMessage(data):Promise<void>
```

> Send a message with a specific payload. You need to handle this message on the WatchOS device. The promise returns successful if the message was able to be sent. If it was not, it will return an error.


Supported Platforms
-------------------

- iOS
