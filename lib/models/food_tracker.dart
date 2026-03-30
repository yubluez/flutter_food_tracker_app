// ไฟล์ที่สร้างขึ้นเพื่อแมปกับข้อมูลใน table ที่เราจะทำงานด้วย
class FoodTracker {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  String? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;
  String? foodImageUrl;

  // construct
  FoodTracker({
    this.id,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
    this.foodImageUrl,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory FoodTracker.fromJson(Map<String, dynamic> json) => FoodTracker(
        id: json['id'],
        foodDate: json['foodDate'],
        foodMeal: json['foodMeal'],
        foodName: json['foodName'],
        foodPrice: json['foodPrice'],
        foodPerson: json['foodPerson'],
        foodImageUrl: json['foodImageUrl'],
      );

  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'foodDate': foodDate,
        'foodMeal': foodMeal,
        'foodName': foodName,
        'foodPrice': foodPrice,
        'foodPerson': foodPerson,
        'foodImageUrl': foodImageUrl,
      };
}
