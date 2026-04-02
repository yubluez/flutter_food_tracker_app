import 'package:flutter/material.dart';
import 'package:flutter_food_tracker_app/models/food_tracker.dart';
import 'package:flutter_food_tracker_app/services/supabase_service.dart';
import 'package:flutter_food_tracker_app/views/add_food_tracker_ui.dart';
import 'package:flutter_food_tracker_app/views/update_delete_food_tracker_ui.dart';

class ShowAllFoodTrackerUi extends StatefulWidget {
  const ShowAllFoodTrackerUi({super.key});

  @override
  State<ShowAllFoodTrackerUi> createState() => _ShowAllFoodTrackerUiState();
}

class _ShowAllFoodTrackerUiState extends State<ShowAllFoodTrackerUi> {
  // สร้าง instance/object/ตำแทน ของ SupabaseService
  final service = SupabaseService();

  // สร้างตัวแปรเก็บข้อมูลที่ได้จากการดึงมาจาก Supabase
  List<FoodTracker> foods = [];

  // สร้างเมธอดเพื่อเรียกใช้วาน service ดึงข้อมูลมาเป็บในตัวแปร
  void loadFoods() async {
    final data = await service.getFoods();

    setState(() {
      foods = data;
    });
  }

  @override
  void initState() {
    super.initState();
    // เรียกใช้เมธอดเพื่อดึงข้อมูล ตอนหน้าจอถูกเปิด
    loadFoods();
  }

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
      // ส่วนของปุ่มเปิดไปหน้าเพิ่ม Food
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodTrackerUi(),
            ),
          ).then((value) {
            // เมื่อกลับมาจากหน้าเพิ่ม task ให้โหลดข้อมูลใหม่
            loadFoods();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // ส่วนของตำแหน่งของปุ่มเปิดไปยังหน้าเพิ่ม Food
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // ส่วนของ body ที่แสดง Logo กับ ข้อมูลที่ดึงมาจาก Supabase
      body: Center(
        child: Column(
          children: [
            // ส่วนแสดง Logo
            SizedBox(height: 40),
            Image.asset(
              'assets/images/logo.png',
              width: 165,
              height: 165,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // ส่วนของ ListView แสดงข้อมูล food_tracker_tb จาก Supabase
            Expanded(
              child: ListView.builder(
                // จำนวนรายการ
                itemCount: foods.length,
                // หน้าตาของแต่ละรายการ
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 35,
                      right: 35,
                    ),
                    child: ListTile(
                      onTap: () {
                        // เปิดไปยังหน้า UpdateDeleteTask แบบย้อนกลับได่
                        // และจะมีการส่งข้อมูลของรายการที่ถูกกดไปยังหน้า UpdateDeleteTask
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateDeleteFoodTrackerUi(
                              foodTracker: foods[index],
                            ),
                          ),
                        ).then((value) {
                          loadFoods();
                        });
                      },
                      leading: foods[index].foodImageUrl! != ""
                          ? Image.network(
                              foods[index].foodImageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/logo.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      title: Text(
                        'กิน: ${foods[index].foodName!}',
                      ),
                      subtitle: Text(
                        'วันที่: ${foods[index].foodDate!}' +
                            '   มื้อ: ${foods[index].foodMeal!}',
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.redAccent,
                      ),
                      tileColor:
                          index % 2 == 0 ? Colors.green[50] : Colors.grey[50],
                      contentPadding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
