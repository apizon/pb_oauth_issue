# pb_oauth_issue

* Replace pocketbase url in `lib/main.dart` with your own
* `flutter run` to run on android or ios
* `flutter run -d web-server` to run as web app

## Issue

### Description

When an error occurs during `authWithOAuth2` flow (typically user hitting `Cancel` on consent screen but I suspect any error will cause this), all subsequent attempts to sign in will fail silently until restarting the app.

I'm not too familiar with realtime subscriptions but it's as if the subscription will not trigger any update after the first error.
That is, until reaching some kind of timeout and then all attempts are triggered at once.

### Steps to reproduce part 1

* Click either `Sign in with Google` or `Sign in with Apple` button
* Enter credentials/select account
* When on consent screen click `Cancel`
  * This redirects to Auth failed screen and prints an error in console as expected
* Repeat the steps above (can be same provider or different it doesn't matter) but this time on consent screen click `Continue`
  * Expected: Sign in succeeds with no error
  * Actual: Auth failed and nothing printed in console (promise never resolves one way or the other)
* Any other subsequent sign in attempts will behave the same until app is restarted or web page reloaded OR some kind of timeout is reached... (see part 2)

### Steps to reproduce part 2

* After the steps above, wait ~5 minutes without restarting the app
* Try to sign in again and hit `Continue`
  * Expected: Sign in succeeds with no error
  * Actual: Sign in succeeds but an exception is thrown (see below) and all previous attempts are printed at once

```
I/flutter (11142): Login error: ClientException: {url: https://localhost:8090/api/collections/users/auth-with-oauth2, isAbort: false, statusCode: 400, response: {data: {}, message: Failed to fetch OAuth2 token., status: 400}, originalError: null}
I/flutter (11142): Login error: ClientException: {url: https://localhost:8090/api/collections/users/auth-with-oauth2, isAbort: false, statusCode: 400, response: {data: {}, message: Failed to fetch OAuth2 token., status: 400}, originalError: null}
I/flutter (11142): Login error: ClientException: {url: https://localhost:8090/api/collections/users/auth-with-oauth2, isAbort: false, statusCode: 400, response: {data: {}, message: Failed to fetch OAuth2 token., status: 400}, originalError: null}
E/flutter (11142): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Bad state: Future already completed
E/flutter (11142): #0      _Completer.completeError (dart:async/future_impl.dart:81)
E/flutter (11142): #1      RecordService.authWithOAuth2.<anonymous closure> (package:pocketbase/src/services/record_service.dart:380)
E/flutter (11142): <asynchronous suspension>
E/flutter (11142): 
I/flutter (11142): Login success: ...
```

