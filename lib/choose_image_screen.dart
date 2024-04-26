import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class ChooseImageScreen extends StatefulWidget {
  const ChooseImageScreen({Key? key}) : super(key: key);

  @override
  State<ChooseImageScreen> createState() => _ChooseImageScreenState();
}

class _ChooseImageScreenState extends State<ChooseImageScreen> {
  late List _recognitions;
  final ImagePicker _picker = ImagePicker();
  late XFile _image;
  String result = '';
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: "lib/model.tflite",
      labels: "lib/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      recognizeImageBinary(pickedFile);
    }
  }

  Future recognizeImageBinary(XFile image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    final imageBytes = await image.readAsBytes();
    final oriImage = img.decodeJpg(imageBytes);
    final resizedImage = img.copyResize(oriImage!, height: 224, width: 224);
    final recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
      numResults: 6,
      threshold: 0.05,
    );
    setState(() {
      _recognitions = recognitions!;
      if (_recognitions.isNotEmpty && _recognitions[0]['index'] == 2) {
        result = 'Monkey';
      } else {
        result = _recognitions[0]['label'];
      }
    });
    print(_recognitions);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  Uint8List imageToByteListFloat32(
      img.Image image,
      int inputSize,
      double mean,
      double std,
      ) {
    final convertedBytes = Float32List((1 * inputSize * inputSize * 3));
    final buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        final pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Image'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Choose from Camera',

                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent, // Adding background color
              ),
              child: Text(
                'Choose from Gallery',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
