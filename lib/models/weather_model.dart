class Weather {
  final String cityName;
  final double temperature; //Nhiệt độ
  final String mainCondition; //Điều kiện thời tiết chính (Clouds, Clear,...)
  //được khai báo với khóa final,
  //giá trị của các thuộc tính sẽ không thay đổi sau khi được khởi tạo

  //Constructor(Yếu cầu phải truyền giá trị khi khởi tạo đối tượng của Class)
  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });
//required đảm bảo tất cả các giá trị này đều được cung cấp khi khởi tạo đối tượng
//if no => bug

//Factory Constructor(Phương thức formJson)
//Nhận 1 đối tượng là Map<String, dynamic> json,
//Đại diện cho dữ liệu JSON được truyền vào từ API Weather
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'], //lấy tên thành phố từ trường 'name' trong JSON
      temperature: json['main']['temp']
          .toDouble(), //lấy nhiệt độ từ trường 'temp' trong phần 'main' của JSON rồi chuyển thành kiểu double
      mainCondition: json['weather'][0][
          'main'], // lấy điều kiện thời tiết chính từ phần tử đầu tiên của mảng "weather" trong json
    );
  }
}
