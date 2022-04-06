import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload {
  ImageUpload._();
  static ImageUpload imageUpload = ImageUpload._();
  File? file;

  uploadImageToApi(Map<String, dynamic> dataMap) async {
    String url = 'url';
    Dio dio = Dio();

    log(dataMap['image'].toString());
    Response response = await dio.post(url,
        data: FormData.fromMap(dataMap),
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer token'
        }));
    log(response.data.toString());
  }
}
