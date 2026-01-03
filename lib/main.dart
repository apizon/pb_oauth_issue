import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

final pb = PocketBase("http://127.0.0.1:8090");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void oauth2(String provider) => pb.collection("users").authWithOAuth2(provider, (url) async {
    await launchUrl(url);
  }).then(
    (r) { print("Login success: $r"); setState(() {}); },
    onError: (e) { print("Login error: $e"); setState(() {}); }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 8.0,
            children: [
              Text(pb.authStore.isValid ? "Logged In" : "Logged Out"),
              SizedBox(height: 64),
              FilledButton(onPressed: () => oauth2("google"), child: Text("Sign in with Google")),
              FilledButton(onPressed: () => oauth2("apple"), child: Text("Sign in with Apple")),
              TextButton(
                onPressed: () { pb.authStore.clear(); setState(() {}); print("Logged out"); },
                child: Text("Logout")
              ),
            ],
          ),
        ),
      ),
    );
  }
}

