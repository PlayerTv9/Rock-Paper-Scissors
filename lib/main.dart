import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rockpaperscissors/Object.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors!',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rock Paper Scissors!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  late ConfettiController _controller;
  @override
  void initState(){
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 2));

  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }


  List<Object> oggetti = [
    Object(0,"Rock","🪨","Paper"),
    Object(1,"Paper","📄","Scissors"),
    Object(2,"Scissors","✂️","Rock"),
  ];

  String? playerChoice;
  String enemy = " ";

  String resultGame = "";

  int punti = 0;


  void play() async{

    if(playerChoice != null){
      int enemyValue = await enemyChoice();
      var enemyName = oggetti[enemyValue];
      if(enemyName.nome == playerChoice){
          resultGame = "Tie!";
      }else if(enemyName.counter == playerChoice){
        resultGame = "You Win!";
        punti++;
        _controller.play();
      }else{
        resultGame = "You lose!";
        punti--;
      }
      setState(() {

      });
    }else{
      await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("You must be choice a move!")));
    }


  }

  Future<int> enemyChoice() async{
    var rng = Random();
    int result = 0;
    for(int i = 0; i <= 50; i++){
      await Future.delayed(Duration(milliseconds: 100));
      result = rng.nextInt(3);
      setState(() {
        enemy = oggetti[result].toString();
      });
    }


    return result;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:
        Column(


          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30,),
            Text(punti.toString(), style: const TextStyle(fontSize: 30),),
            Expanded(child:
            Center(

          child:Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ConfettiWidget(
                     confettiController: _controller,
                     blastDirectionality: BlastDirectionality.explosive,
                     emissionFrequency: .05,
                     numberOfParticles: 20,
                     gravity: .3,
                   ),
                   DropdownMenu<String>(
                     initialSelection: oggetti.first.oggetto,
                     dropdownMenuEntries: oggetti.map((value){
                       return DropdownMenuEntry(value: value.nome, label: value.toString(),
                           style: MenuItemButton.styleFrom(
                               textStyle: const TextStyle(fontSize: 18),
                               padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12)
                           ));
                     }).toList(),
                     label: Text(playerChoice ?? 'seleziona un valore', style: const TextStyle(fontSize: 18),),
                     menuStyle: MenuStyle(
                         padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                         visualDensity: VisualDensity.standard
                     ),
                     onSelected: ((String? scelta){
                       setState(() {
                         playerChoice = scelta;
                       });
                     }),
                   ),
                   Text(enemy, style: const TextStyle(fontSize: 18),),
                   TextButton(onPressed: play, child: const Text("Play!")),
                   Text(resultGame),
                 ],
               ),


            ))],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
