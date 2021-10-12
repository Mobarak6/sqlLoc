import 'package:flutter/material.dart';
import 'package:location_app/Provider/placeHolder.dart';
import 'package:location_app/Screen/formScreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FormScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<PlaceHolders>(context, listen: false)
              .fatchAndSetPlace(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<PlaceHolders>(
                  // child:  Center(
                  //   child: Text('List is Empty..'),
                  // ),
                  builder: (context, placeHolder, _child) =>
                      placeHolder.placeList.length == 0
                          ? const Center(
                              child: Text('List is Empty..'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, i) => Card(
                                elevation: 9,
                                color: Colors.deepPurpleAccent[50],
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(
                                        placeHolder.placeList[i].imageFile),
                                  ),
                                  title: Text(placeHolder.placeList[i].title),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                              itemCount: placeHolder.placeList.length,
                            ),
                )),
    );
  }
}
