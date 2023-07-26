import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Second Page.dart';
import 'config.dart';

class PlayPage extends StatefulWidget {
  int curent_pos,cur_level;
   PlayPage(this.curent_pos,this.cur_level);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  int cur_level=0;
  int curent_pos=0;
  timer() async {
    for (int i = 5; i >= 0; i--)
    {
      await Future.delayed(Duration(seconds: 1));
      a = i;
      if (i == 0) {
        temp = List.filled(myimg.length, false);
        while (temp.contains(false)) {
          await Future.delayed(Duration(seconds: 1));
          i++;
          a = i;
          setState(() {});
        }
      }
      setState(() {});
    }
  }

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('.png'))
        .toList();

    setState(() {
      images = imagePaths;
      images.shuffle();

      for(int i=0;i<level_puzzle[curent_pos]/2 ;i++)
        {
          myimg.add(images[i]);
          myimg.add(images[i]);
        }
      myimg.shuffle();
    });
  }

  SharedPreferences ? pref ;
  share_pref() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    cur_level = widget.cur_level;
    curent_pos = widget.curent_pos;
    temp =List.filled(level_puzzle[curent_pos], true);
    myimg.clear();
    timer();
    _initImages();
    share_pref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${curent_pos+1}   Time: $a"),
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          Expanded(child: Center(
            child: Container(margin: EdgeInsets.all(10),
              child: GridView.builder(itemCount: myimg.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,mainAxisSpacing: 5,crossAxisSpacing: 5),
                itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                      if(!temp[index] && pos==1)
                        {
                          temp[index]=true;
                          pos=2;
                          x1=index;
                        }
                      if(!temp[index] && pos==2)
                      {
                        temp[index]=true;
                        pos=0;
                        x2=index;

                            if(myimg[x1]==myimg[x2])
                              {
                                print("pic match");
                                pos=1;
                                if(!temp.contains(false))
                                {
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: Container(height: 50,alignment: Alignment.center,width: double.infinity,
                                        child: Text("NEW RECORD!"),color: Colors.teal,),
                                      content: Container(height: 150,width: 100,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("$a SECONDS"),
                                            Text("NO TIME LIMIT"),
                                            Text("LEVEL $cur_level"),
                                            Text("WELL DONE"),
                                            Container(color: Colors.teal,
                                                child: TextButton(
                                                  onPressed:  () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return SecondPage();},)); },
                                                  child: Text("Ok",style: TextStyle(color: Colors.white),),))
                                          ],
                                        ),
                                      ),
                                    );
                                  },);
                                  print(a);
                                  print(curent_pos);
                                  print(cur_level);
                                  if (a<second[curent_pos]) {
                                    pref!.setInt("seconds${curent_pos}", a);
                                  }
                                  if (second[curent_pos]==0) {
                                    pref!.setInt("seconds${curent_pos}", a);
                                  }
                                  print(second);
                                    
                                  if (widget.curent_pos==cur_level) {
                                    cur_level++;
                                    pref!.setInt("levelno", cur_level);
                                  }
                                   print(cur_level);
                                }
                                setState(() {});
                              }
                            else
                            {
                              Future.delayed(Duration(seconds: 1)).then((value) {
                                setState(() {
                                  temp[x1]=false;
                                  temp[x2]=false;
                                  pos=1;
                                });
                              });
                            }
                      }
                  },
                  child: Visibility(
                      child: Container(
                    decoration: BoxDecoration(color: Colors.cyan,
                        image: DecorationImage(image: AssetImage("${myimg[index]}")),
                        borderRadius: BorderRadius.circular(5),
                    border: Border.all())),
                  visible: temp[index],
                  replacement:  Container(
                      decoration: BoxDecoration(color: Colors.cyan,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()))),
                );
              },),
            ),
          ))
        ],
      ),
    );
  }
}
