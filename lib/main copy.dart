import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<CSDigitState> _key = GlobalKey();

  int _counter = 0;
  //final Widget a1 ,a2,b1,b2;

  var a1,a2,a5;

  CSDigit aboveDigit;
  CSDigit belowDigit;// = new CSDigit(title: '12', spacing: 15, isAbove: false, degree: _counter );

 


  AnimationController _controller;
  Animation _animation;
  bool _animationRunning = false;

  @override
  void initState() {

    super.initState();
     aboveDigit = CSDigit(key: _key,  title: '97', spacing: 1, isAbove: true, degree: _counter);
     belowDigit = CSDigit( title: '12', spacing: 1, isAbove: false, degree: _counter );

     a5 = aboveDigit.upClip;
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller =
        new AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            }
            if (status == AnimationStatus.dismissed) {
              _animationRunning = false;
            }
          })
          ..addListener(() {
            setState(() {
              _animationRunning = true;
            });
          });

          print ('Above Spacing:'  + aboveDigit.spacing.toString());
  }




  void _incrementCounter() {
    setState(() {
      _counter++;
      _key.currentState.methodInChild(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                  //aboveDigit.downClip,
                 // belowDigit,
                  aboveDigit,
                 // belowDigit.downClip,
              ],
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}






class CSDigit extends StatefulWidget {
  final Function function;
  final String title;
  double spacing = 1;
  bool isAbove = false;
  Widget upClip, downClip;
  int degree;

  CSDigit({Key key, this.title, this.spacing, this.isAbove,this.upClip, this.downClip, this.degree, this.function}) : super(key: key);

  @override
  CSDigitState createState() => CSDigitState();
}

class CSDigitState extends State<CSDigit> with SingleTickerProviderStateMixin {

  bool startAnimation = false;
  int stage = 1;

  AnimationController animationController;
  Animation animation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;

  Widget frontUp, frontDown, backUp, backDown;



  @override
  void initState() {
      super.initState();

      frontUp = makeUpperClip(myDigit('12'));
      frontDown = makeLowerClip(myDigit('12'));

      backUp = makeUpperClip(myDigit('23'));
      backDown = makeLowerClip(myDigit('23'));


      widget.upClip = makeUpperClip(myDigit('12'));
      widget.downClip = makeLowerClip(myDigit('13'));
      animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
            ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              print ('Animation finished');

              setState(() {
                stage++;
                if (stage == 2) 
                  {
                    print ('second stage started...');
                    animationController.reset();
                    animationController.forward();
                }
              });
            }
            if (status == AnimationStatus.dismissed) {
              print ('Animation Dismissed');
            }
          })
          ..addListener(() {
            setState(() {
                print ('animation running');
            });
          });
      animation =Tween<double>(end: 1, begin: 0).animate(animationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          animationStatus = status;
        });      

  }
   
   void methodInChild(int value) {
     print ('Child invoked');
     setState(() {
        widget.degree = value;  
     });
     
   } 

   Widget myDigit(String title) {
     return Container(
                alignment: Alignment.center,
                width: 96.0,
                height: 128.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Text(title,
                  //'${widget.title}', // ${widget.degree}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 80.0,
                      color: Colors.yellow),
                ),
              );
   }

   Widget makeUpperClip(Widget widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }

    Widget makeLowerClip(Widget widget) {
      return ClipRect(
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.5,
          child: widget,
        ),
      );
    }  

    Widget makeTappableTransform(Widget widget) {
      return GestureDetector(
        child: widget,
        onTap: () {
            Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0006)
                ..rotateX(math.pi / 2),
              child: widget,
            );

        },
      );

    }

  void upperTap() {

    if (!widget.isAbove) return; // En üstteki değilsen birşey yapma...

    print ('upper tap');
    setState(() {
     // startAnimation = true;
    });
          if (animationStatus == AnimationStatus.dismissed) {
            print ('forwarding...');
            animationController.forward();
          } else {
            animationController.reverse();
          }    
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
        children: [
                  Column( //backWidget
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (stage == 2) ?
                                  Transform(
                                    alignment: Alignment.bottomCenter,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.006)
                                      ..rotateX(math.pi/2 -math.pi/3 * animationController.value),
                                    child: backUp,
                                  ) :         
                                  Transform(
                                          transform: Matrix4.identity()..translate(-10.0, -15.0, -10.0),
                                          child: backUp,),                   
                            //makeUpperClip(myDigit()),
                            Padding(
                              padding: EdgeInsets.only(top: widget.spacing),
                            ),
                            backDown,
                          ],
                  ),
                  
                   Column( //frontWidget
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text ('Aradaki', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 80.0,
                      color: Colors.blue),),
                          ],),
                          
                  Column( //frontWidget
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                upperTap();
                              },
                              child:
                               (stage >= 2) ? Transform(
                                          transform: Matrix4.identity()..translate(-15.0, -15.0, 0.0),
                                          child: frontUp,
                               )
                                          : frontUp,
                                  ),
                            //makeUpperClip(myDigit()),
                            Padding(
                              padding: EdgeInsets.only(top: widget.spacing),
                            ),
                            (stage == 1) ?
                                  Transform(
                                    alignment: Alignment.topCenter,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.006)
                                      ..rotateX(-math.pi /2 * animationController.value),
                                    child: frontDown,
                                  ) : 
                                  (stage == 1) ?
                                  frontDown :
                                  Container(),              //makeLowerClip(myDigit()),
                          ],
                  ),
        ],
    );
    
    
  }

  @override
  Widget buildOld(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  upperTap();
                },
                child: (stage == 1) ? 
                    widget.upClip :
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.006)
                        ..rotateX(math.pi /2 * animationController.value),
                      child: widget.upClip,
                    ),



              ),
              //makeUpperClip(myDigit()),
              Padding(
                padding: EdgeInsets.only(top: widget.spacing),
              ),
              (widget.isAbove == true) && (stage == 1) ?
                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.006)
                        ..rotateX(-math.pi /2 * animationController.value),
                      child: widget.downClip,
                    ) : 
                    (stage == 1) ?
                    widget.downClip :
                    Container(),              //makeLowerClip(myDigit()),
            ],
    );
  }
}