import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_food_tracker_app/models/food_tracker.dart';
import 'package:flutter_food_tracker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddFoodTrackerUi extends StatefulWidget {
  const AddFoodTrackerUi({super.key});

  @override
  State<AddFoodTrackerUi> createState() => _AddFoodTrackerUiState();
}

class _AddFoodTrackerUiState extends State<AddFoodTrackerUi> {
  // สร้างตัวควบคุม TextField และตัวแปรที่จะต้องเก็บข้อมูลที่ผู้ใช้ป้อนหรือเลือก เพื่อบันทึกใน food_tracker_tb
  TextEditingController foodNameCtrl = TextEditingController();
  String foodMeal = 'เช้า';
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
  String? foodImageUrl = '';

  //ตัวแปรเก็บไฟล์ที่ใช้อัปโหลด
  File? file;

  //---- เปิดกลองถ่ายภาพ และกำหนดค่ารูปเพื่อ upload ----

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  //-------------------------

  //---- เปิดปฏิทันเลือกวันที่ และกำหนดค่าวันที่ ----
  DateTime? selectedDate;

  Future<void> pickDate() async {
    // เปิดปฎิทิน
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    // เอาค่าวันที่เลือกจากปฏิทินไปกำหนดให้กับ foodDateCtrl

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  //-------------------------

  // เมธอดอัปโหลดไฟล์และบันทึกข้อมูลจากการกดปุ่ม
  Future<void> save() async {
    // Validate UI ว่าผู้ใช้งานป้อนหรือเลือกข้อมูลครบหรือยัง ถ้ายังแสดงข้อมความแจ้ง
    if (foodNameCtrl.text.isEmpty ||
        foodPriceCtrl.text.isEmpty ||
        foodPersonCtrl.text.isEmpty ||
        foodDateCtrl.text.isEmpty ||
        foodMeal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาป้อนข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return; // อย่าลืม return เพื่อให้ไม่ทำงานต่อ หรือ ให้ออกจากการทำงานของเมธอดนี้เลย
    }

    // สร้าง instance/object/ตัวแทน ของ SupabaseService เพื่อใช้งานเมธอดต่างๆ ที่สร้างไว้ใน SupabaseService
    final service = SupabaseService();

    // ตรวจสอบว่ามีการถ่ายหรือเลือกรูปหรือไม่ ถ้ามีก็อัปโหลดไฟล์ ไปที่ food_tracker_bk
    //แล้วเอา URL ของไฟล์ที่อัปโหลดเก็บในตัวแปรเพื่อใช้บันทึกใน food_tracker_tb
    if (file != null) {
      // หาก file ไม่เท่ากับ null แปลว่าได้มีการถ่า/เลือกรูป
      foodImageUrl = await service.uploadFile(file!);
    }

    // บันทึกข้อมูลลงใน food_tracker_tb
    // แพ็กข้อมูล
    final foodTracker = FoodTracker(
      foodName: foodNameCtrl.text,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDateCtrl.text,
      foodImageUrl: foodImageUrl,
      foodMeal: foodMeal,
    );

    // เรียกใช้งานเมธอด insertFood ที่สร้างไว้ใน SupabaseService เพื่อบันทึกข้อมูลลงใน food_tracker_tb
    await service.insertFood(foodTracker);

    // แจ้งผลการทำงาน (แสดงเป็น SnackBar or AlertDialog)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    //ย้อนกลับไปยังหน้าหลัก (ShowAllTaskUi)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Food Tracker (เพิ่ม)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 28,
            right: 28,
            bottom: 50,
          ),
          child: Center(
            child: Column(
              children: [
                // ส่วนแสดงรูปและรูปกล้องเพื่อเปิดกล้อง
                file == null
                    ? InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: 150,
                          color: Colors.grey[300],
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Image.file(
                          file!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(height: 20),
                // ป้อนกินอะไร
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น KFC, Pizza',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินมื้อไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เช้า';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เช้า' ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.19,
                          40,
                        ),
                      ),
                      child: Text(
                        'เช้า',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'กลางวัน';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'กลางวัน' ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.25,
                          40,
                        ),
                      ),
                      child: Text(
                        'กลางวัน',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เย็น';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เย็น' ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.19,
                          40,
                        ),
                      ),
                      child: Text(
                        'เย็น',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'ว่าง';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'ว่าง' ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.19,
                          40,
                        ),
                      ),
                      child: Text(
                        'ว่าง',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ป้อนกินไปเท่าไหร่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPriceCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 299.50',
                  ),
                ),
                SizedBox(height: 20),
                // ป้อนกินกันกี่คน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกันกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 3',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินไปวันไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปวันไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  readOnly: true,
                  controller: foodDateCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    pickDate();
                  },
                ),
                SizedBox(height: 20),
                // ปุ่มบันทึก
                ElevatedButton(
                  onPressed: () {
                    save();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    "บันทึก",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // ปุ่มยกเลิก
                ElevatedButton(
                  onPressed: () {
                    // เคลียร์หน้าจอ
                    setState(() {
                      foodNameCtrl.clear();
                      foodDateCtrl.clear();
                      foodPriceCtrl.clear();
                      foodPersonCtrl.clear();
                      file = null;
                      foodMeal = 'เช้า';
                      foodImageUrl = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
