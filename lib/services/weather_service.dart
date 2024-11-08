import 'dart:convert'; // Cung cấp các hàm tiện ích để mã hóa
//và giải mã JSON (để xử lý dữ liệu JSON từ API).

import 'package:geocoding/geocoding.dart';
//Cung cấp khả năng chuyển đổi tọa độ (vĩ độ, kinh độ)
//thành thông tin vị trí chi tiết như tên thành phố (geocoding).

import 'package:geolocator/geolocator.dart';
//Sử dụng để lấy vị trí hiện tại của người dùng (vĩ độ và kinh độ).
import 'package:http/http.dart' as http;
//Dùng để gửi yêu cầu HTTP đến API của OpenWeatherMap để lấy dữ liệu thời tiết.

import '../models/weather_model.dart';

class WeatherService {
  //Đây là URL cơ bản để truy cập API OpenWeatherMap.
  //BASE_URL chỉ định endpoint cho dịch vụ thời tiết.
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  // Để truy cập API, bạn cần có khóa API (API key).
  //Khóa này được truyền vào khi khởi tạo lớp WeatherService
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    //Dòng này gửi yêu cầu HTTP GET đến API, bao gồm tên thành phố (cityName),
    //khóa API (apiKey) và đơn vị nhiệt độ (ở đây là độ C với tham số units=metric).
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    //Nếu mã phản hồi HTTP là 200, điều này có nghĩa là yêu cầu thành công
    //và dữ liệu JSON từ API được giải mã thành một đối tượng Weather bằng phương thức Weather.fromJson().
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Nhận sự cho phép từ người dùng
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Tìm đến vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high
        //desiredAccuracy đã cũ
        );

    //Chuyển đổi vị trí thành danh sách các đối tượng dấu vị trí
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //Trích xuất tên thành phố từ dấu vị trí đầu tiên
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
