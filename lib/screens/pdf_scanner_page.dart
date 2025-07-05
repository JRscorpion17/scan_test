import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../pdf_scanner.dart';

class PdfScannerPage extends StatefulWidget {
  const PdfScannerPage({super.key});

  @override
  _PdfScannerPageState createState() => _PdfScannerPageState();
}

class _PdfScannerPageState extends State<PdfScannerPage> {
  List<String> pdfFiles = [];

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 11+
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();

      if (status.isPermanentlyDenied) {
        openAppSettings(); // redirige vers les paramètres
      }

      return status.isGranted;
    }
    return false;
  }

  @override
  Future<void> initState() async {
    super.initState();

    bool granted = await requestStoragePermission();
    if (!granted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission Granted")));
      return;
    }

    scanPdfs();
  }

  Future<void> scanPdfs() async {
    final files = await PdfScanner.getAllPdfFiles();
    setState(() {
      pdfFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF trouvés")),
      body:
          pdfFiles.isEmpty
              ? Center(child: Text("Aucun PDF trouvé"))
              : ListView.builder(
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  final path = pdfFiles[index];
                  return ListTile(
                    title: Text(path.split('/').last),
                    subtitle: Text(path),
                  );
                },
              ),
    );
  }
}
