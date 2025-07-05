import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan_test/screens/pdf_scanner_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permission Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            requestStoragePermission().then((granted) {
              if (granted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Permission Granted")),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PdfScannerPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Permission Denied")),
                );
              }
            });
          },
          child: const Text("Request Permissions"),
        ),
      ),
    );
  }
}
