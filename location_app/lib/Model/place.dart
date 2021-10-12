import 'dart:io';

class Place {
  final String title;
  final String id;
  final File imageFile;
  final LocationPlace? locationPlace;

  Place(
      {required this.title,
      required this.id,
      required this.imageFile,
      this.locationPlace});
}

class LocationPlace {
  final String langtute;
  final String latetute;
  final String Address;

  LocationPlace(this.langtute, this.latetute, this.Address);
}
