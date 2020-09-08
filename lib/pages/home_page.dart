import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band_model.dart';

class HomePage extends StatefulWidget{
    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    List<Band> bands = [
        Band(id:'1', name: 'Metallica', votes:5),
        Band(id:'2', name: 'Bon Jovi', votes:7),
        Band(id:'3', name: 'Mana', votes:4),
        Band(id:'4', name: 'Korn', votes:11),
    ];

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'BandNames',
                    style: TextStyle(
                        color: Colors.black87,
                    ),
                ),
                elevation: 1,
                backgroundColor: Colors.white,
            ),
            body: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                elevation: 1,
                onPressed: _addNewBAnd
            ),
        );
    }

    Widget _bandTile(Band band) {
        return Dismissible(
            key: Key(band.id),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction){
                print(direction);
            },
            background: Container(
                padding: EdgeInsets.only(left: 8.0),
                color: Colors.red,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Delete band'
                    ),
                ),
            ),
            child: ListTile(
                leading: CircleAvatar(
                    child: Text(band.name.substring(0,2)),
                    backgroundColor: Colors.blue[100],
                ),
                title: Text(band.name),
                trailing: Text(
                    '${band.votes}',
                    style: TextStyle(fontSize: 20)
                ),
                onTap: (){
                    print(band.name);
                },
            ),
        );
    }

    _addNewBAnd(){
        final textController = new TextEditingController();

        if (Platform.isAndroid){
            return showDialog(
                context: context,
                builder: (context){
                    return AlertDialog(
                        title: Text('New band name:'),
                        content: TextField(
                            controller: textController,
                        ),
                        actions: [
                            MaterialButton(
                                child: Text('Add'),
                                elevation: 5,
                                textColor: Colors.blue,
                                onPressed: ()=>addBandToList(textController.text),
                            )
                        ],
                    );
                }
            );
        }
        showCupertinoDialog(
            context: context,
            builder: (_){
                return CupertinoAlertDialog(
                    title: Text('New band name'),
                    content: CupertinoTextField(
                        controller: textController,
                    ),
                    actions: [
                        CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text('Add'),
                            onPressed: ()=>addBandToList(textController.text),
                        ),
                        CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('Cancel'),
                            onPressed: ()=>Navigator.pop(context),
                        ),
                    ],
                );
            }
        );
    }
    void addBandToList(String name){
        print(name);
        if (name.length>1){
            this.bands.add(
                new Band(id:DateTime.now().toString(), name:name, votes:0)
            );
            setState(() {});
        }
        Navigator.pop(context);
    }
}