import 'package:flutter/material.dart';
import 'package:fryo/src/bloc/provider.dart';
import 'package:fryo/src/preferencias_usuario/preferencias_ususario.dart';
import './src/screens/Dashboard.dart';
import './src/screens/ProductPage.dart';
import './src/screens/SignInPage.dart';

void main() async {

   final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      final prefs = new PreferenciasUsuario();
    return Provider(
        child: MaterialApp(
      title: 'Essalud',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) {
          if (prefs.token!='' ) {
            print('Este es mi token '+prefs.token);
            return Dashboard();
          } else {
             print('no hay token ');
            return SignInPage();
          }
        },
        '/productPage': (BuildContext context) => ProductPage(),
      },
    )
    );
  }
}
