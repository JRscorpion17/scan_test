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
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
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
                  MaterialPageRoute(builder: (context) => const PdfScannerPage()),
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
