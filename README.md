---
Title: Apple Watch Plugin
Description: Connect to Apple Watch via Watch Connectivity framework and send/receive messages.
---

## Installation

1. `cordova plugin add https://github.com/thessler27/watch-plugin.git

## Utilization

1. Initialize: `window.plugins.applewatch.initializeSession():Promise<boolean>`. Returns `true` if successful connection, and throws an error (`false`) if unsuccessful.


Supported Platforms
-------------------

- iOS
