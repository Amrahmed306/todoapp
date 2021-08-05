import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var taskTitleController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is InsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomSheetIsShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertIntoDatabase(
                      taskTitle: taskTitleController.text,
                      taskTime: taskTimeController.text,
                      taskDate: taskDateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) {
                          return Container(
                            padding: EdgeInsets.all(
                              20,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: taskTitleController,
                                    keyboardType: TextInputType.text,
                                    validatorFunction: (String value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Title',
                                    prefixIcon: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                    controller: taskTimeController,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        taskTimeController.text =
                                            value.format(context);
                                      }).catchError((error) {
                                        print(
                                            'error while closing bottom sheet ${error.toString()}');
                                      });
                                    },
                                    validatorFunction: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Time',
                                    prefixIcon: Icons.watch_later_outlined,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                    controller: taskDateController,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2021-08-30"),
                                      ).then((value) {
                                        taskDateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    validatorFunction: (String value) {
                                      if (value.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    labelText: 'Task Date',
                                    prefixIcon: Icons.calendar_today_rounded,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(
                          isShown: false,
                          fabIcon: Icons.edit,
                        );
                      });
                  cubit.changeBottomSheetState(
                    isShown: true,
                    fabIcon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.floatingButtonIcon,
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! GetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'New'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
