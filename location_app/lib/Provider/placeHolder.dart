import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:location_app/Model/place.dart';
import 'package:location_app/helpers/db_Helper.dart';

class PlaceHolders with ChangeNotifier {
  List<Place> _placeList = [];
  List<Place> get placeList {
    return [..._placeList];
  }

  Future<void> addPlace(String getTitle, File getImageFile) async {
    final place = Place(
        title: getTitle,
        id: DateTime.now().toString(),
        locationPlace: null,
        imageFile: getImageFile);
    _placeList.insert(
      0,
      place,
    );

    notifyListeners();
    try {
      await DatabaseHelper.insert('places', {
        'id': place.id,
        'title': place.title,
        'image': place.imageFile.path,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fatchAndSetPlace() async {
    try {
      final dataList = await DatabaseHelper.fatchData('places');

      _placeList = dataList
          .map((e) => Place(
                title: e['title'],
                id: e['id'],
                imageFile: File(e['image']),
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
