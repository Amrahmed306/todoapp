import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks.dart';
import 'package:todoapp/modules/done_tasks.dart';
import 'package:todoapp/modules/new_tasks.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStat());

  Database database;

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  IconData floatingButtonIcon = Icons.edit;

  bool bottomSheetIsShown = false;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEX, time TEXT, status TEXT)')
            .then((value) => print('table created'))
            .catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(GetDatabaseState());
    });
    ;
  }

  void insertIntoDatabase({
    @required String taskTitle,
    @required String taskTime,
    @required String taskDate,
  }) async {
    database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$taskTitle", "$taskDate", "$taskTime", "new")');
    }).then((value) {
      print('$value Row successfully added');
      emit(InsertDatabaseState());
      getDataFromDatabase(database);
    }).catchError((error) {
      print('error while inserting new row ${error.toString()}');
    });
  }

  void changeBottomSheetState({@required isShown, @required IconData fabIcon}) {
    bottomSheetIsShown = isShown;
    floatingButtonIcon = fabIcon;
    emit(AppBottomSheetState());
  }

  void updateDatabase({
    @required String status,
    @required int id,
  }) {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(UpdatedDatabaseState());
    });
  }

  void deleteDatabase({
    @required int id,
  }) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }
}
