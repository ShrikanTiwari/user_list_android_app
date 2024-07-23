

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String address;
  final String company;
  final String location;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: _formatPhoneNumber(json['phone']),
      website: json['website'],
      address: "${json['address']['street']}, ${json['address']['suite']}, ${json['address']['city']}, ${json['address']['zipcode']}",
      company: json['company']['name'],
      location: "${json['address']['geo']['lat']}, ${json['address']['geo']['lng']}");
  }
//the response was comming as "1-770-736-8031 x56442 of phone so this will eliminate the text which are not being used
  static String _formatPhoneNumber(String phoneNumber) {
    // Regex to match and remove the extension
    final RegExp regex = RegExp(r'(\d{3}-\d{3}-\d{4})');
    final match = regex.firstMatch(phoneNumber);
    return match != null ? match.group(0)! : phoneNumber;
  }
}
