import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagerecognitiontemplate/scan_controller.dart';

class RealtimeCamScreen extends StatelessWidget {
  const RealtimeCamScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Camera'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 400,
              child: GetBuilder<ScanController>(
                init: ScanController(),
                builder: (controller) {
                  return controller.isCameraInitialized.value
                      ? CameraPreview(controller.cameraController)
                      : const Center(
                    child: CircularProgressIndicator(),
                  ); // Replaced 'Initializing....' with a CircularProgressIndicator
                },
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<ScanController>(
              builder: (controller) {
                return Text(
                  controller.categoryResult.value ?? 'No Object',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
