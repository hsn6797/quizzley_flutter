import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Model/question_brain.dart';

void main() => runApp(Quizzler());

Question_Brain QB = Question_Brain();
int TIME_TO_ANSWER = 20; // 20 seconds

int secondsLeft = TIME_TO_ANSWER;

class Quizzler extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade800,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  Timer _timer;

  _QuizPageState(){
    // Start the Timer when App first Start
    startTimer();
  }

  // User Defined Functions
  void startTimer() {
    // call every 1 second
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
            (Timer timer) => setState(
              () {
            if (secondsLeft < 1) {
              print('Time up!');

              // pass invalid value so its always be false
              checkAnswer('Not Matched');

              secondsLeft = TIME_TO_ANSWER;

            } else {
              secondsLeft = secondsLeft - 1;
              print(secondsLeft.toString() + ' seconds left');
            }
          },
        ),
      );

  }
  void checkAnswer(correctUserAnswer) {
    bool correctAnswer = QB.getQuestionAnswer();
    setState(() {

      if(QB.isFinished()){

        // When Quiz ends stop the Timer
        if(_timer != null && _timer.isActive){
          _timer.cancel();
          _timer = null;
        }


        Alert(
          context: context,
          title: 'Finished!',
          desc: 'Quiz Finished!',
          buttons: [
            DialogButton(
              child: Text(
                "Start Again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Start The Timer again
                startTimer();
            },
              width: 120,
            )
          ],
        ).show();

        // reset all variables when quiz finished
        resetDefault();

      }else{
        if (correctUserAnswer == correctAnswer) {
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        QB.nextQuestion();
      }
    });
  }
  void resetDefault(){
    QB.reset();
    scoreKeeper = [];
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                QB.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Time Left: '+ secondsLeft.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
                secondsLeft = TIME_TO_ANSWER;

              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
                secondsLeft = TIME_TO_ANSWER;

              },
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Row(
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}