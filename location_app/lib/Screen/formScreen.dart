import 'dart:developer';
import 'dart:io';

import 'package:location_app/Provider/placeHolder.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  static const String routeName = 'formSceeen';
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _titleControler = TextEditingController();
  var conState = false;
  File? _imageFile;

  @override
  void dispose() {
    _titleControler.dispose();

    super.dispose();
  }

  Future<void> openImage(ImageSource imageSource) async {
    final imagePicker = await ImagePicker.platform
        .getImage(source: imageSource, maxHeight: 600, maxWidth: 400);
    if (imagePicker == null) {
      return;
    }

    setState(() {
      _imageFile = File(imagePicker.path);
      conState = false;
    });
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile!.path);
    final finalImage = await _imageFile!.copy('${appDir.path}/$fileName');
    //log(finalImage.path);
  }

  void onSaved() async {
    if (_imageFile == null || _titleControler.text == '') {
      showDialog(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
                title: const Text('Enter Input again'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ));
    } else {
      Provider.of<PlaceHolders>(context, listen: false)
          .addPlace(_titleControler.text, _imageFile!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    log('formWidget');
    return Scaffold(
        appBar: AppBar(
          title: Text('form'),
        ),
        body: Container(
          // margin: EdgeInsets.only(top: 50),
          // padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      conState = false;
                    });
                  },
                  child: Container(
                    color: conState ? Colors.black26 : Colors.white,
                    //margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Column(
                      children: [
                        //ImageWidgets(_imageFile, conState),
                        imageInput(),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: TextFormField(
                            validator: (value) {
                              if (value != null) {
                                return;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            controller: _titleControler,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              conState
                  ? Container(
                      height: 150,
                      color: Colors.blueGrey,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => openImage(ImageSource.camera),
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.greenAccent,
                              size: 50,
                            ),
                          ),
                          IconButton(
                            onPressed: () => openImage(ImageSource.gallery),
                            icon: Icon(
                              Icons.photo_album_rounded,
                              color: Colors.greenAccent,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      // margin: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: onSaved,
                          icon: Icon(Icons.done),
                          label: Text('Submit')),
                    )
            ],
          ),
        ));
  }

  Stack imageInput() {
    return Stack(
      children: [
        CircleAvatar(
          maxRadius: 80,
          backgroundColor: Colors.black12,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : AssetImage('lib/assets/images/head-avator.png')
                  as ImageProvider<Object>,
          //_imageFile==null? AssetImage('lib/assets/images/head-avator.png'): FileImage(_imageFile!),
          minRadius: 80,
        ),
        Positioned(
          bottom: 5,
          right: 0,
          child: CircleAvatar(
            child: IconButton(
              onPressed: () async {
                setState(
                  () {
                    conState = !conState;
                  },
                );
              },
              icon: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ],
    );
  }
}
