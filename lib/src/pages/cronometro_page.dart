import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/src/pages/theme.dart';
import 'package:pomodoro/utils/constants.dart';
import 'package:pomodoro/model/pomodoro_status.dart';
import 'dart:async';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';


class CronometroPage extends StatefulWidget{

  @override
  createState() => _CronometroPageState();

}

const _btnTextStart = 'START';
const _btnTextResumePomodoro = 'RESUME';
const _btntextResumeBreak = 'RESUME';
const _btnTextPause = 'PAUSE';
const _btnTextReset = 'RESET';

class _CronometroPageState extends State <CronometroPage>{
  
  static AudioCache player = AudioCache();
  int remainingTime = pomodoroTotalTime;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer _timer;
  int totalTime=0;
  int totalTimeM=0;
  String mainBtnText = _btnTextStart;
  int timeSB=shortBreakTime~/60;
  int timeLB=longBreakTime~/60;
  
  static DateTime now=DateTime.now();
  int dd=now.day;
  int mm=now.month;
  int dda;
  int mma;

  @override
  void initState(){
    getTiempoEstudio();
    getFecha();
    super.initState();
    player.load('bell.mp3');
  }

  getTiempoEstudio() async{
    totalTimeM = await getTimeStudy();
  }

  getFecha()async{
    now=DateTime.now();
    dd=now.day;
    mm=now.day;
    dda=getDia();
    mma=getMes();
    if(dda!=dd && mma!=mm){
      totalTimeM=0;
    }
    setDia(dd);
    setMes(mm);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    //final theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Focus Timer',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
            ),
          ),
        //backgroundColor: Colors.blueGrey[900],
        //shadowColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4_rounded), 
            onPressed: (){
              currentTheme.toggleTheme();
            },
          )
        ],
      ),
      //backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25.0),
            Text('Today you have concentrated\n                    $totalTimeM min',
              style: TextStyle(
                //color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
              )
            ),
            SizedBox(height: 30.0),
            Text(statusDescription[pomodoroStatus],
            style: TextStyle(
                //color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
              )
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 22.0),
                  /*InkWell(
                        onTap: ()async {
                              Duration resultingDuration = await showDurationPicker(
                                context: context, 
                                initialTime: new Duration(minutes: 25),
                              );
                              setState(() {
                                //pomodoroTotalTime = resultingDuration ~/ Duration.microsecondsPerSecond;
                                if(resultingDuration!=null){
                                  pomodoroTotalTime=resultingDuration.inSeconds;
                                }
                                _stopCountdown();
                              }
                              );
                            },
                        child: CircularPercentIndicator(
                          
                          radius: 200.0,
                          lineWidth: 8.0,
                          percent: _getPomodoroPercentage(),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            _secondsToFormatedString(remainingTime),
                              style: TextStyle(
                                fontSize: 45, 
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Open Sans',
                              ),
                          ),
                          progressColor: statusColor[pomodoroStatus],
                        ),
                  ),*/
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        
                        radius: 200.0,
                        lineWidth: 8.0,
                        percent: _getPomodoroPercentage(),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          _secondsToFormatedString(remainingTime),
                            style: TextStyle(
                              fontSize: 45, 
                              //color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                            ),
                        ),
                        progressColor: statusColor[pomodoroStatus],
                      ),
                      ConstrainedBox(constraints: BoxConstraints.tightFor(width: 150,height:50),
                        child: Builder(
                          builder: (BuildContext context) => ElevatedButton(
                            onPressed: ()async {
                              Duration resultingDuration = await showDurationPicker(
                                context: context, 
                                initialTime: new Duration(minutes: 25),
                              );
                              setState(() {
                                //pomodoroTotalTime = resultingDuration ~/ Duration.microsecondsPerSecond;
                                if(resultingDuration!=null){
                                  pomodoroTotalTime=resultingDuration.inSeconds;
                                }
                                _stopCountdown();
                              }
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(Colors.transparent),
                              shadowColor:MaterialStateProperty.all(Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 0.0),
                      Builder(
                        builder: (BuildContext context) => FlatButton(
                          onPressed: ()async {
                            Duration resultingDuration = await showDurationPicker(
                              context: context, 
                              initialTime: new Duration(minutes: 5),
                            );
                            Scaffold.of(context).setState(() {
                              //pomodoroTotalTime = resultingDuration ~/ Duration.microsecondsPerSecond;
                              if(resultingDuration!=null){
                                shortBreakTime=resultingDuration.inSeconds;
                                timeSB=shortBreakTime~/60;
                              }
                              _stopCountdown();
                            });
                          },
                          child: Text('$timeSB min',
                                  style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        )
                        ),
                        ),                        
                      ),
                      Expanded(child: SizedBox()),
                      Builder(
                        builder: (BuildContext context) => FlatButton(
                          onPressed: ()async {
                            Duration resultingDuration = await showDurationPicker(
                              context: context, 
                              initialTime: new Duration(minutes: 15),
                            );
                            Scaffold.of(context).setState(() {
                              //pomodoroTotalTime = resultingDuration ~/ Duration.microsecondsPerSecond;
                              if(resultingDuration!=null){
                                longBreakTime=resultingDuration.inSeconds;
                                timeLB=longBreakTime~/60;
                              }
                              _stopCountdown();
                            });
                          },
                          child: Text('$timeLB min',
                                  style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        )
                        ),
                        ),                        
                      ),
                      SizedBox(width: 00.0),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      IconButton(icon: Icon(Icons.free_breakfast), 
                      onPressed: _startShortBreakPressed,
                      //color: Colors.white,
                      iconSize: 40.0,
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(icon: Icon(Icons.directions_walk), 
                      onPressed: _startLongBreakPressed,
                      //color: Colors.white,
                      iconSize: 40.0,
                      ),
                      SizedBox(width: 15.0),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20.0),
                      Text('Short Break',
                      style: TextStyle(
                          
                          //color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                        )
                      ),
                      Expanded(child: SizedBox()),
                      SizedBox(width: 20.0),
                      Text('Long Break',
                      style: TextStyle(
                            //color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                          )
                      ),
                      SizedBox(width: 20.0),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  ConstrainedBox(constraints: BoxConstraints.tightFor(width: 150,height:50),
                  child: ElevatedButton(
                    child: Text(mainBtnText,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      )
                    ),
                    onPressed: _mainButtonPressed,
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.red,
                    )
                  ),
                  ),
                  SizedBox(height: 20.0),
                  ConstrainedBox(constraints: BoxConstraints.tightFor(width: 150,height:50),
                  child: ElevatedButton(
                    child: Text(_btnTextReset,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      )
                    ),
                    onPressed: _resetButtonPressed,
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.red,
                    )
                  ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runingPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() async{
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runingPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;      
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runingPomodoro;
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  totalTime++,
                  if(totalTime%60==0){
                    totalTimeM++,
                    setTimeStudy(totalTimeM),
                  },
                  setState(() {
                    remainingTime=remainingTime-1;
                    mainBtnText = _btnTextPause;
                  })
                }
              else
                {
                  _playSound(),
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState((){
                    remainingTime = pomodoroTotalTime;
                    mainBtnText = _btnTextStart;
                  }),
                }
        }
    );
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  _resetButtonPressed() {
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _startShortBreakPressed(){
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        pomodoroStatus = PomodoroStatus.pausedShortBreak;
        setState(() {
          remainingTime = shortBreakTime;
        });
        break;
      case PomodoroStatus.pausedLongBreak:
        pomodoroStatus = PomodoroStatus.pausedShortBreak;
        setState(() {
          remainingTime = shortBreakTime;
        });
        break;
    }
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState(() {
                    mainBtnText = _btnTextStart;
                  }),
                }
            });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btntextResumeBreak;
    });
  }

  _startLongBreakPressed(){
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        pomodoroStatus = PomodoroStatus.pausedLongBreak;
        setState(() {
          remainingTime = longBreakTime;
        });
        break;
      case PomodoroStatus.pausedShortBreak:
        pomodoroStatus = PomodoroStatus.pausedLongBreak;
        setState(() {
          remainingTime = longBreakTime;
        });
        break;
    }
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState(() {
                    mainBtnText = _btnTextStart;
                  }),
                }
            });
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _playSound() {
    player.play('bell.mp3');
  }
}

setTimeStudy(int totalTimeM) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setInt("alreadytime", totalTimeM);
}

getTimeStudy() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    int tiempoTotalEstudiado = preferences.getInt("alreadytime") ?? 0;
    return tiempoTotalEstudiado;
}

setDia(int dia) async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setInt("alreadyday", dia);
}

getDia() async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  int dia = preferences.getInt("alreadyday") ?? 0;
  return dia;
}

setMes(int mes) async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  preferences.setInt("alreadymonth", mes);
}

getMes() async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  int mes = preferences.getInt("alreadymonth") ?? 0;
  return mes;
}
