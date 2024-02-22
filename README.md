# local_storage

LocalStorage in Dart simplifies file operations for saving, loading, and deleting files, providing a
concise solution for efficient local storage in applications.

### Usage

```dart
void main() async {
  // Example 1: Saving bytes as a file
  final bytes = Uint8List.fromList([72, 101, 108, 108, 111]);
  final filePath = await LocalStorage.i.saveAsBytes("hello.txt", bytes);
  print("File saved at: $filePath");

  // Example 2: Loading a file
  final loadedFile = await LocalStorage.i.load("hello.txt");
  if (loadedFile != null) {
    print("File loaded successfully: ${loadedFile.path}");
  } else {
    print("File does not exist or an error occurred.");
  }

  // Example 3: Deleting a file
  await LocalStorage.i.delete("hello.txt");
  print("File deleted.");

  // Example 4: Getting the root directory path
  final rootPath = await LocalStorage.i.root;
  print("Root directory path: $rootPath");
}
```

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