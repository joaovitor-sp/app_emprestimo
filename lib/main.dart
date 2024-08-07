import 'package:app_emprestimo/src/module/comparato_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LoanApp());
}

class LoanApp extends StatelessWidget {
  const LoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/comparator',
      routes: {
        '/comparator': (context) => const ComparatorPage(),
      },
    );
  }
}
