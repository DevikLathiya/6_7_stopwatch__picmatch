import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(MaterialApp(home: Stopwatch(),));
}
class Stopwatch extends StatefulWidget {
  const Stopwatch({Key? key}) : super(key: key);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {

  bool push=false;
  int count = 0;

  Stream get() async* {
    while(true){
      await Future.delayed(Duration(seconds: 1));
      count++;
      yield count;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(height: 60,width: 250,alignment: Alignment.center,
                child: Text("Stop Watch",style: TextStyle(fontSize: 28)),
                decoration: BoxDecoration(color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(10)
                ),),
              StreamBuilder(
                stream: (push==true) ? get() : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState==ConnectionState.active) {
                    print(snapshot.connectionState);
                    return Container(margin: EdgeInsets.all(20),
                      height: 250,width: double.infinity,alignment: Alignment.center,
                      child:  Text("${snapshot.data}",
                          style: TextStyle(fontSize: 40)),
                      decoration: BoxDecoration(color: Colors.teal,
                          borderRadius: BorderRadius.circular(15)
                      ),
                    );
                  }
                  else{
                    return Container(margin: EdgeInsets.all(20),
                      height: 250,width: double.infinity,alignment: Alignment.center,
                      child:  Text("$count",
                          style: TextStyle(fontSize: 40)) ,
                      decoration: BoxDecoration(color: Colors.teal.shade300,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black,width: 2)
                      ),
                    );
                  }
                },),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    setState(() {
                      push =true;
                    });
                  }, child: Text("START")),
                  ElevatedButton(onPressed: () {
                    setState(() {
                      push=false;
                    });
                  }, child: Text("PUSH")),
                  ElevatedButton(onPressed: () {
                    setState(() {
                      count=0;
                      push =false;
                    });
                  }, child: Text("RESET")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
