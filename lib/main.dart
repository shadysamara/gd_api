import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloder_test/image_upload_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MaterialApp(home: SamahUi()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('ddd'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: RaisedButton(onPressed: () async {
            // await ImageUpload.imageUpload.selectImage();
            // await ImageUpload.imageUpload.uploadImageToApi();
            // final dir = await getApplicationDocumentsDirectory();
            // var _localPath = dir.path + 'flutter_tutorial.pdf';
            // final savedDir = Directory(_localPath);
            // await savedDir.create(recursive: true);
            // log(savedDir.path);
            // final taskId = await FlutterDownloader.enqueue(
            //   url:
            //       'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf',
            //   savedDir: _localPath,
            //   showNotification:
            //       true, // show download progress in status bar (for Android)
            //   openFileFromNotification:
            //       true, // click on notification to open downloaded file (for Android)
            // );
            // final tasks = await FlutterDownloader.loadTasks();
          }),
        ));
  }
}

class SamahUi extends StatefulWidget {
  @override
  State<SamahUi> createState() => _SamahUiState();
}

class _SamahUiState extends State<SamahUi> {
  File? file;
  selectImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(pickedFile!.path);
    setState(() {});
  }

  Future<MultipartFile> convertImageToMultipart(File file) async {
    MultipartFile multipartFile = await MultipartFile.fromFile(file.path,
        filename: file.path.split('/').last);
    return multipartFile;
  }

  TextEditingController controller1 = TextEditingController();

  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Samah'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(controller1, 'ArName'),
            CustomTextField(controller2, 'EnName'),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                    child: file == null
                        ? Container()
                        : Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                    height: 300,
                    width: 300,
                    color: Colors.grey)),
            const SizedBox(
              height: 100,
            ),
            RaisedButton(
                child: const Text('submit'),
                onPressed: () async {
                  Map<String, dynamic> dataMap = {
                    'name_ar': controller1.text,
                    'name_en': controller2.text,
                    'image': await convertImageToMultipart(file!)
                  };
                  ImageUpload.imageUpload.uploadImageToApi(dataMap);
                })
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const CustomTextField(this.controller, this.labelText);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
