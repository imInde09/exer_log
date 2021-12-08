import 'package:exerlog/Bloc/exercise_bloc.dart';
import 'package:exerlog/Models/exercise.dart';
import 'package:exerlog/Models/sets.dart';
import 'package:exerlog/Models/workout.dart';
import 'package:exerlog/UI/exercise/set_widget.dart';
import 'package:exerlog/UI/exercise/totals_widget.dart';
import 'package:exerlog/UI/global.dart';
import 'package:exerlog/UI/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final String name;
  final Exercise exercise;
  Function(Exercise) addExercise;
  Function(Exercise) updateExisitingExercise;

  ExerciseCard(
      {required this.name,
      required this.exercise,
      required this.addExercise,
      required this.updateExisitingExercise});
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  int index = 0;
  List<SetWidget> setList = [];
  double height = 180;
  TotalsData totalData =
      new TotalsData(['0 sets', '0 reps', '0 kgs', '0 kg/rep']);
  late TotalsWidget totalWidget;

  @override
  void initState() {
    widget.exercise.sets.add(new Sets(0, 0, 0, 0));
    setList.add(new SetWidget(
        name: widget.name,
        exercise: widget.exercise,
        addNewSet: addNewSet,
        id: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalWidget = new TotalsWidget(totalData, index);
    return Container(
      height: height + 40,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    spreadRadius: 5),
              ]),
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          padding: EdgeInsets.all(20),
          height: height,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: mediumTitleStyleWhite,
                    ),
                    totalWidget
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.white.withOpacity(0.2),
              ),
              Column(
                children: [
                  Container(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Reps",
                              style: smallTitleStyleWhite,
                            ),
                          ),
                          width: 60,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Sets",
                              style: smallTitleStyleWhite,
                            ),
                          ),
                          width: 60,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Weight",
                              style: smallTitleStyleWhite,
                            ),
                          ),
                          width: 60,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Rest",
                              style: smallTitleStyleWhite,
                            ),
                          ),
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: setList,
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 170,
          left: 170,
          top: height - 15,
          child: Container(
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFF34D1C2), Color(0xFF31A6DC)],
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: backgroundColor,
                ),
                onPressed: () {
                  setState(() {
                    height += 40;
                    setList.add(new SetWidget(
                        name: widget.name,
                        exercise: widget.exercise,
                        addNewSet: addNewSet,
                        id: widget.exercise.sets.length));
                    widget.exercise.sets.add(new Sets(0, 0, 0, 0));
                    widget.addExercise(widget.exercise);
                  });
                },
              ),
            ),
          ),
        )
      ]),
    );
  }

  addNewSet(newSet, id) {
    widget.updateExisitingExercise(widget.exercise);
    setState(() {
      widget.exercise.sets[id] = newSet;
      setTotals();
    });
  }

  void setTotals() {
    List<String> returnTotals = totalData.total;
    int totalSets = 0;
    int totalReps = 0;
    double totalKgs = 0;
    for (Sets sets in widget.exercise.sets) {
      totalSets += sets.sets;
      int reps = sets.sets > 0 ? sets.sets * sets.reps : sets.reps;
      totalReps += reps;
      totalKgs += reps * sets.weight;
    }
    double avgKgs = (totalKgs / totalReps).roundToDouble();
    returnTotals[0] = totalSets.toString() + " sets";
    returnTotals[1] = totalReps.toString() + " reps";
    returnTotals[2] = totalKgs.toString() + " kgs";
    returnTotals[3] = avgKgs.toString() + " kg/rep";
    setState(() {
      totalData = new TotalsData(returnTotals);
      totalWidget = new TotalsWidget(totalData, index);
    });
  }
}