import 'package:flutter/material.dart';
import 'package:fryo/src/bloc/provider.dart';
import 'package:fryo/src/preferencias_usuario/preferencias_ususario.dart';
import './src/screens/SignInPage.dart';
import './src/screens/SignUpPage.dart';
import './src/screens/Dashboard.dart';
import './src/screens/ProductPage.dart';



void main() async { 
   final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
      title: 'Essalud',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SignInPage(),
      routes: <String, WidgetBuilder> {
        '/signup': (BuildContext context) =>  SignUpPage(),
        '/signin': (BuildContext context) =>  SignInPage(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/productPage': (BuildContext context) => ProductPage(),
      },
    )
    );
  }
}
