import 'package:budget_app/responsive_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    setPathUrlStrategy();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBToMyfJSYyQGB5c3e07pszgNPqd7NNj1g',
        authDomain: 'budget-ao-app.firebaseapp.com',
        projectId: 'budget-ao-app',
        storageBucket: 'budget-ao-app.appspot.com',
        messagingSenderId: '1059404075440',
        appId: '1:1059404075440:web:536f252936bf855412c675',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResponsiveHandler(),
    );
  }
}
