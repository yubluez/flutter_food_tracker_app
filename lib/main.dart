import 'package:flutter/material.dart';
import 'package:flutter_food_tracker_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //----- ตั้งค่าการใช้งาน Supabase ที่จะทำงานด้วย -----
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xyykmfoywnccceziohhw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5eWttZm95d25jY2NlemlvaGh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2MTc1ODUsImV4cCI6MjA5MDE5MzU4NX0.qEQz2QH6-Ua4VTwvcuKOq6ait0h7P-ZvOgaJRc0oPgM',
  );
  //---------------------------------------------
  runApp(FlutterFoodTrackerApp());
}

class FlutterFoodTrackerApp extends StatefulWidget {
  const FlutterFoodTrackerApp({super.key});

  @override
  State<FlutterFoodTrackerApp> createState() => _FlutterFoodTrackerAppState();
}

class _FlutterFoodTrackerAppState extends State<FlutterFoodTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
