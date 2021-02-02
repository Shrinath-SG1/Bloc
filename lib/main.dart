
import 'dart:async';

import 'package:bloc/Register.dart';
import 'package:bloc/model/EventCounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterPg(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = Bloc_Counter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Bloc Example"),centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
         stream: _bloc.counter,
          initialData: 0,
          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Image.network("https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/flutter_bloc_logo_full.png",width: 250,height: 200,),
                //Text("", style: TextStyle(fontStyle: FontStyle.italic,fontSize: 25),),
                Container(padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width*0.10,
                ),
                    child: Text("Press Below Button ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                Text(
                    '${snapshot.data}',
                    style: TextStyle(fontSize: 30)
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(padding: const EdgeInsets.only(left: 40,bottom: 180),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              onPressed: (){
                //print("Increment");
                //class bloc class by passing IncrementEvent
                _bloc.counterEventSink.add(IncrementEvent());
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(padding: const EdgeInsets.only(left: 60,bottom: 190
          ),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              backgroundColor: Colors.red,
              onPressed: (){
                //print("Decrement");
                //class bloc class by passing DecrementEvent
                _bloc.counterEventSink.add(DecrementEvent());
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //dispose all the controller
    _bloc.dispose();
  }
}


// async enable

class Bloc_Counter{
  int _counter = 0;

  //StreamCountroller handle input and output
  final _counterStateController = StreamController<int>();

  // Sink in Flutter can be easily stated, In Simple Words Sink = Import
  StreamSink<int> get _inCounter =>_counterStateController.sink;

  // Stream in Flutter can be easily stated, In Simple Words Stream = Output
  Stream<int> get counter =>_counterStateController.stream;

  //event controller to trigger which event has occurred
  final _counterEventController = StreamController<EventCounter>();

  Sink<EventCounter> get counterEventSink =>_counterEventController.sink;

  Bloc_Counter(){
    _counterEventController.stream.listen((_mapEventtoState));
  }

  void _mapEventtoState(EventCounter event){
    // depending on event either increment or decrement the counter variable
    if(event is IncrementEvent)
      _counter++;
    else
      _counter--;

    _inCounter.add(_counter);

  }

  // Dispose the Controller, Very important step, Otherwise you may get memory leak
  void dispose(){
    _counterStateController.close();
    _counterEventController.close();
  }
}