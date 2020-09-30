import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/socket_service.dart';
import '../models/band_model.dart';

class HomePage extends StatefulWidget{
    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    List<Band> bands = [];

    @override
    Widget build(BuildContext context){
        final socketService = Provider.of<SocketService>(context);
        this.bands = socketService.bands;
        
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'BandNames',
                    style: TextStyle(
                        color: Colors.black87,
                    ),
                ),
                elevation: 1,
                actions: [
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: socketService.serverStatus==ServerStatus.OnLine ? 
                            Icon(
                                Icons.check_circle,
                                color: Colors.blue[300]
                            ) :
                            Icon(
                                Icons.offline_bolt,
                                color: Colors.red
                            ),
                    ),
                ],
                backgroundColor: Colors.white,
            ),
            body: Column(
                children: [
                    _showChart(),
                    Expanded(
                        child: ListView.builder(
                            itemCount: bands.length,
                            itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]),
                        ),
                    ),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                elevation: 1,
                onPressed: _addNewBAnd
            ),
        );
    }

    Widget _bandTile(Band band) {
        final socketService = Provider.of<SocketService>(context, listen:false);

        return Dismissible(
            key: Key(band.id),
            direction: DismissDirection.startToEnd,
            onDismissed: (_){
                socketService.deleteBand(band.id);
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
                onTap: ()=>socketService.voteBand(band.id),
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
        if (name.length>1){
            final socketService = Provider.of<SocketService>(context, listen:false);
            socketService.addBand(name);
        }
        Navigator.pop(context);
    }

    Widget _showChart(){
        Map<String, double> dataMap = new Map();
        this.bands.forEach((band){
            dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
        });
        final List<Color> colorList = [
            Colors.blue[50],
            Colors.blue[200],
            Colors.pink[50],
            Colors.pink[200],
            Colors.yellow[50],
            Colors.yellow[200],
        ];
        return dataMap.length<1 ? SizedBox.shrink() : Container(
            padding: EdgeInsets.only(top:15),
            width: double.infinity,
            height: 200,
            child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartRadius: MediaQuery.of(context).size.width / 2.1,
                colorList: colorList,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                ),
                chartValuesOptions: ChartValuesOptions(
                    decimalPlaces: 0,
                    showChartValueBackground: false,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                ),
            ),
        );
    }
}