import 'package:flutter/foundation.dart';
import 'package:oauth2_client/oauth2_client.dart';
//import 'package:meta/meta.dart';

class OktaAuthClient extends OAuth2Client {
  OktaAuthClient({@required String redirectUri, @required String customUriScheme}): super(
    authorizeUrl: 'https://auth.bytener.com/oauth2/default/v1/authorize', //Your service's authorization url
    tokenUrl: 'https://auth.bytener.com/oauth2/default/v1/token', //Your service access token url
    revokeUrl: 'https://auth.bytener.com/oauth2/default/v1/revoke',
    redirectUri: redirectUri,
    customUriScheme: customUriScheme,
  ) {
    this.accessTokenRequestHeaders = {
      'Accept': 'application/json'
    };
  }
}