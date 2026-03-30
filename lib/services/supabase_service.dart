// ไฟล์นี้ใช้สำหรับสร้างการทำงานต่างๆ กับ Supabase

// CRUD กับ Table->Database (PostgreSQL)->Supabase
// upload/delete file กับ Bucket->Storage->Supabase

import 'dart:io';

import 'package:flutter_food_tracker_app/models/food_tracker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/object/ตัวแทน ของ Supabase เพื่อใช้งาน
  final supabase = Supabase.instance.client;

  // สร้างคำสั่ง/เมธอดการทำงานต่างๆ กับ Supabase
  // เมธอดดึงข้อมูลงานทั้งหมดจาก task_tb และ return ค่าข้อมูลที่ได้จากการดึงไปใช้
  Future<List<FoodTracker>> getFoods() async {
    // ดึงข้อมูลงานทั้งหมดจาก food_tracker_tb
    final data = await supabase.from('food_tracker_tb').select('*');

    // return ค่าข้อมูลที่ได้จากการดึงไปใช้งาน
    return data
        .map((foodTracker) => FoodTracker.fromJson(foodTracker))
        .toList();
  }

  // เมธอดอัปโหลดไฟล์ไปยัง task_tb และ return ค่าข้อมูลที่อยู่รูปที่ได้จากการอัปโหลดไปใช้งาน
  Future<String?> uploadFile(File file) async {
    // สร้างชื่อไฟล์ใหม่ให้ไฟล์เพื่อไม่ให้ซ้ำกัน
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    // อัปโหลดไปยัง food_tracker_bk
    await supabase.storage.from('food_tracker_bk').upload(filename, file);

    //return ค่าข้อมูลที่อยู่รูป image url ที่ได้จากการอัปโหลดไปใช้งาน
    return supabase.storage.from('food_tracker_bk').getPublicUrl(filename);
  }

  // เมธอดเพิ่มข้อมูลไปยัง task_tb
  Future insertFood(FoodTracker foodTracker) async {
    //เพิ่มข้อมูลไปยัง food_tracker_tb
    await supabase.from('food_tracker_tb').insert(foodTracker.toJson());
  }

  // เมธอดลบไฟล์ที่อัปโหลดไปยัง task_tb

  // เมธอดแก้ไขข้อมูลใน -> task_tb
  Future updateFood(int id, Map data) async {
    await supabase.from('food_tracker_tb').update(data).eq('id', id);
  }

  // เมธอดลบข้อมูลจาก task_tb
  Future deleteFood(int id) async {
    await supabase.from('food_tracker_tb').delete().eq('id', id);
  }
}
