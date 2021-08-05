import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType keyboardType,
  @required Function validatorFunction,
  Function onSubmit,
  bool isClickable = true,
  Function onChange,
  Function onTap,
  @required String labelText,
  @required IconData prefixIcon,
  bool isPassword = false,
  IconData suffixIcon,
  Function suffixPressed,
}) {
  return TextFormField(
    validator: validatorFunction,
    controller: controller,
    obscureText: isPassword,
    enabled: isClickable,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefixIcon),
      suffixIcon: IconButton(
        onPressed: suffixPressed,
        icon: Icon(suffixIcon),
      ),
    ),
  );
}

Widget taskItem(Map model, context) {
  return Dismissible(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model["time"]}',
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.check_box_rounded,
              color: Colors.green,
            ),
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'done',
                id: model['id'],
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.archive_rounded,
              color: Colors.red,
            ),
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'archived',
                id: model['id'],
              );
            },
          ),
        ],
      ),
    ),
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(id: model['id']);
    },
  );
}

Widget conditionalBuilder() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
