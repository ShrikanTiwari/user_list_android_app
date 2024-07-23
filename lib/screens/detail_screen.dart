import 'package:assingmet_test/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:assingmet_test/screens/list_screen/user_model.dart'; 
class UserDetailsScreen extends StatelessWidget {
  final User user;

  UserDetailsScreen({required this.user});


  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        color: AppPallete.customColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Icon and User Name
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppPallete.borderColor,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppPallete.greyColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
        
              // Email and Address with icons
              ListTile(
                leading: const Icon(Icons.email,color: AppPallete.borderColor,),
                title: Text(user.email,style: const TextStyle(color: AppPallete.greyColor),),
              ),
              ListTile(
                leading: const Icon(Icons.location_on,color: AppPallete.borderColor,),
                title: Text(user.address ,style: const TextStyle(
                    color:AppPallete.greyColor,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              const SizedBox(height: 16),
              
              // Open in Google Maps
              TextButton(
                onPressed: () {
                  final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(user.location)}';
                  _launchURL(url);
                  print(user.location);
                },
                child: const Text(
                  'Open in Google Maps',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
        
              // Phone and Website
              ListTile(
                leading: const Icon(Icons.phone,color: AppPallete.borderColor,),
                title: Text(user.phone,style: const TextStyle(color:Colors.blue,fontSize: 20, decoration: TextDecoration.underline,),),
                onTap: () => _launchURL('tel:${user.phone}'),
              ),
              ListTile(
                leading: const Icon(Icons.web,color: AppPallete.borderColor,),
                title: Text(user.website,style: const TextStyle(color: Colors.blue,fontSize: 20,),),
                onTap: () => _launchURL('https://${user.website}'),
              ),
              const SizedBox(height: 16),
        
              // Company Details
              RichText(
          text: TextSpan(
            text: 'Company: ',
            style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppPallete.borderColor,
            ),
            children: <TextSpan>[
        TextSpan(
          text: user.company,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppPallete.greyColor,
          ),
        ),
            ],
          ),
        )
        
            ],
          ),
        ),
      ),
    );
  }
}
