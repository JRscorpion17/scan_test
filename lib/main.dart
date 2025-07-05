import 'package:flutter/material.dart';
import 'package:scan_test/screens/pdf_scanner_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PdfScannerPage());
  }
}
