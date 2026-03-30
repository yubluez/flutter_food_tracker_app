import 'package:flutter/material.dart';

class UpdateDeleteFoodTrackerUi extends StatefulWidget {
  const UpdateDeleteFoodTrackerUi({super.key});

  @override
  State<UpdateDeleteFoodTrackerUi> createState() =>
      _UpdateDeleteFoodTrackerUiState();
}

class _UpdateDeleteFoodTrackerUiState extends State<UpdateDeleteFoodTrackerUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Food Tracker',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
