import 'package:flutter/services.dart';

class PdfScanner {
  static const platform = MethodChannel('pdf_scanner_channel');

  static Future<List<String>> getAllPdfFiles() async {
    try {
      final List<dynamic> files = await platform.invokeMethod('getAllPdfFiles');
      return files.cast<String>();
    } on PlatformException catch (e) {
      print("Erreur lors du scan PDF : ${e.message}");
      return [];
    }
  }
}
