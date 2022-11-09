import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nuceu/notificationservice.dart';
import 'package:nuceu/view/screens/create_account_screen.dart';
import 'package:nuceu/view/screens/create_event.dart';
import 'package:nuceu/view/screens/detalhesDoEvento.dart';
import 'package:nuceu/view/screens/home_screen.dart';
import 'package:nuceu/view/screens/login_screen.dart';
import 'package:nuceu/view/screens/quem_somos.dart';
import 'package:nuceu/view/screens/tela_inicial.dart';
import 'package:nuceu/view/screens/videos_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyC-6MXlDkcAdZTXwEOQl3HnSzeSaxCym_s',
        appId: '1:882302187340:android:1d79d3577052fadc9a01e9',
        messagingSenderId: '882302187340',
        projectId: 'univasf-nuceu-firebase'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuceu - APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        sliderTheme:
            SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
      ),
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('pt')],
      routes: {
        '/': (context) => TelaInicial(),
        '/home-screen': (context) => const HomeScreen(),
        '/login-screen': (context) => const LoginScreen(),
        '/quem-somos': (context) => const QuemSomos(),
        '/videos-screen': (context) => VideosScreen(),
        '/edit-post-screen': (context) => EditPostScreen(),
        '/create-account-screen': (context) => CreateAccount(),
        '/create-event': (context) => CreateEvent(),
        //'/' : (context) => EditPostScreen(),
        //'/home-screen': (context) => const HomeScreen(),
      },
    );
  }
}
