import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates states) {},
      builder: (BuildContext context, AppStates states) {
        return ConditionalBuilder(
          condition: doneTasks.length > 0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => taskItem(
              doneTasks[index],
              context,
            ),
            separatorBuilder: (
              context,
              index,
            ) =>
                Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[200],
              ),
            ),
            itemCount: doneTasks.length,
          ),
          fallback: (context) => conditionalBuilder(),
        );
      },
    );
  }
}
