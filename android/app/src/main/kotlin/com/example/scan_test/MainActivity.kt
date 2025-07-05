package com.example.scan_test

import android.content.ContentUris
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "pdf_scanner_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getAllPdfFiles") {
                val pdfFiles = getAllPdfFiles()
                result.success(pdfFiles)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAllPdfFiles(): List<String> {
        val pdfList = mutableListOf<String>()

        val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
        } else {
            MediaStore.Files.getContentUri("external")
        }

        val projection = arrayOf(
            MediaStore.Files.FileColumns._ID,
            MediaStore.Files.FileColumns.DISPLAY_NAME,
            MediaStore.Files.FileColumns.DATA,
            MediaStore.Files.FileColumns.MIME_TYPE
        )

        val selection = "${MediaStore.Files.FileColumns.MIME_TYPE} = ?"
        val selectionArgs = arrayOf("application/pdf")

        val sortOrder = "${MediaStore.Files.FileColumns.DATE_ADDED} DESC"

        val query = contentResolver.query(
            collection,
            projection,
            selection,
            selectionArgs,
            sortOrder
        )

        query?.use { cursor ->
            val dataIndex = cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA)
            while (cursor.moveToNext()) {
                val path = cursor.getString(dataIndex)
                pdfList.add(path)
            }
        }

        return pdfList
    }
}
