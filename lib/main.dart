import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hsgjkvjgoadmgcvsyfkq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzZ2prdmpnb2FkbWdjdnN5ZmtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0MjAwMzAsImV4cCI6MjA2Mzk5NjAzMH0.SRzYLQQ-e3jKbwBu5A-3787xVuOrAAm3bJ1pVnm3AO4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'StockerFlow',
      home: AuthGate(),
    );
  }
}
