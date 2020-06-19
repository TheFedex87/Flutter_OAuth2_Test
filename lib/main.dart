import 'dart:io';

import 'package:OAuth2_Test/services/OktaAuthClient.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'OAuth2 Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLogging = false;
  OAuth2Client _client;
  OAuth2Helper _oauth2Helper;

  @override
  void initState() {
    _client = OktaAuthClient(
        redirectUri: "it.thefedex87.oauth2demo://oauth2redirect",
        customUriScheme: "it.thefedex87.oauth2demo");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _oauth2Helper = OAuth2Helper(_client,
        grantType:
            OAuth2Helper.AUTHORIZATION_CODE, //default value, can be omitted
        clientId: '0oa4bhcvq6YdNDDkE357',
        scopes: ['email', 'openid', 'offline_access']);
    print(_oauth2Helper);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLogging
            ? FutureBuilder<AccessTokenResponse>(
                future: _oauth2Helper.getToken(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("LOGGING IN...");
                  }
                  print("Access Token");
                  print(snapshot.data.accessToken);
                  print("Refresh Token");
                  print(snapshot.data.refreshToken);
                  _isLogging = false;
                  return Column(
                    children: <Widget>[
                      Text("Access Token"),
                      Text(snapshot.data.accessToken),
                      Text("Refresh Token"),
                      Text(snapshot.data.refreshToken != null
                          ? snapshot.data.refreshToken
                          : "NULL"),
                      RaisedButton(
                        child: Text("Logout"),
                        onPressed: logout,
                      ),
                    ],
                  );
                },
              )
            : FutureBuilder<AccessTokenResponse>(
                future: _oauth2Helper.getTokenFromStorage(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("LOADING...");
                  }
                  if (snapshot.data == null) {
                    return Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Login"),
                          onPressed: () {
                            setState(() {
                              _isLogging = true;
                            });
                          },
                        ),
                      ],
                    );
                  } else {
                    if (!snapshot.data.isValid()) {
                      return FutureBuilder(
                        future: _oauth2Helper.getToken(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Refreshing token");
                          }
                          return Column(
                            children: <Widget>[
                              Text("Access Token"),
                              Text(snapshot.data.accessToken),
                              Text("Refresh Token"),
                              Text(snapshot.data.refreshToken != null
                                  ? snapshot.data.refreshToken
                                  : "NULL"),
                              RaisedButton(
                                child: Text("Logout"),
                                onPressed: logout,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    print("Token is valid");
                    print("Access Token");
                    print(snapshot.data.accessToken);
                    print("Refresh Token");
                    print(snapshot.data.refreshToken);
                    return Column(
                      children: <Widget>[
                        Text("Access Token"),
                        Text(snapshot.data.accessToken),
                        Text("Refresh Token"),
                        Text(snapshot.data.refreshToken != null
                            ? snapshot.data.refreshToken
                            : "NULL"),
                        RaisedButton(
                          child: Text("Logout"),
                          onPressed: logout,
                        ),
                      ],
                    );
                  }
                }),
      ),
    );
  }

  void logout() async {
    var rsp = await _oauth2Helper.disconnect();
    //var rsp = await _client.revokeAccessToken(snapshot.data, '0oa4bhcvq6YdNDDkE357');
    //await _client.revokeAccessToken(snapshot.data);

    setState(() {});
  }

  Future<AccessTokenResponse> getAccessToken() async {
    AccessTokenResponse token = await _oauth2Helper.getToken();

    /*_oauth2Helper = OAuth2Helper(_client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE, //default value, can be omitted
      clientId: '0oa4bhcvq6YdNDDkE357',
      
      scopes: ['email', 'openid']);*/

    //Require an Access Token with the Authorization Code grant
    /*AccessTokenResponse tknResp = await _client.getTokenWithAuthCodeFlow(
        clientId: '0oa4bhcvq6YdNDDkE357',
        enablePKCE: true,
        scopes: ['email', 'openid']);*/
    /*OAuth2Client client = GitHubOAuth2Client(
      redirectUri: 'it.thefedex87.oauth2demo://oauth2redirect',
      customUriScheme: 'it.thefedex87.oauth2demo');
    AccessTokenResponse tknResp = await client.getTokenWithAuthCodeFlow(
      clientId: 'myclientid',
      clientSecret: 'myclientsecret',
      scopes: ['repo']);*/
    //client.revokeRefreshToken(tknResp);
    //var responseRevoke = await client.revokeToken(oauth2Helper.accessTokenParams);
    //print(tknResp);
    return token;
  }
}
