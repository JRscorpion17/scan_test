import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class PdfScannerPage extends StatefulWidget {
  const PdfScannerPage({super.key});

  @override
  PdfScannerPageState createState() => PdfScannerPageState();
}

class PdfScannerPageState extends State<PdfScannerPage> {
  List<String> pdfFiles = [];

  Future<void> scanPdfs() async {
    bool granted = await Permission.storage.request().isGranted;
    if (!granted) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        pdfFiles = result.paths.whereType<String>().toList();
      });
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      var status = await Permission.manageExternalStorage.request();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDFs trouvés")),
      body: ListView.builder(
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pdfFiles[index].split('/').last),
            subtitle: Text(pdfFiles[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanPdfs,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
