### Example:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage/local_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocalStorageDemo(),
    );
  }
}

class LocalStorageDemo extends StatefulWidget {
  const LocalStorageDemo({super.key});

  @override
  State<LocalStorageDemo> createState() => _LocalStorageDemoState();
}

class _LocalStorageDemoState extends State<LocalStorageDemo> {
  final LocalStorage imageStorage = LocalStorage.i;
  File? pickedImage;
  File? savedImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });

      final bytes = await pickedImage!.readAsBytes();

      await imageStorage.saveAsBytes('my_image.jpg', bytes);
      loadImage();
    }
  }

  Future<void> loadImage() async {
    final loadedImage = await imageStorage.load('my_image.jpg');
    if (mounted) {
      setState(() {
        savedImage = loadedImage;
      });
    }
  }

  Future<void> deleteImage() async {
    await imageStorage.delete('my_image.jpg');
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Storage Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            pickedImage != null
                ? Image.file(
              pickedImage!,
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            )
                : const Text('No Picked Image'),
            const SizedBox(height: 20),
            savedImage != null
                ? Image.file(
              savedImage!,
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            )
                : const Text('No Saved Image'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteImage,
              child: const Text('Delete Image'),
            ),
          ],
        ),
      ),
    );
  }
}
```