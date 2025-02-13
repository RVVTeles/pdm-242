import 'dart:convert'; // For encoding/decoding JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables to store country information
  String countryName = '';
  String region = '';
  String languages = '';
  String capital = '';
  String currencies = '';
  String borders = '';

  // Text editing controller for user input
  final TextEditingController _countryController = TextEditingController();

  // Function to fetch data from the API
  Future<void> fetchData(String country) async {
    final String apiUrl = 'https://restcountries.com/v3.1/name/$country?fields=name,region,languages,capital,currencies,borders';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the response if successful
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      if (data.isNotEmpty) {
        // Extract the desired data
        setState(() {
          countryName = data[0]['name']['common']; // Country's name
          region = data[0]['region'];
          languages = data[0]['languages'] != null
              ? data[0]['languages'].values.join(', ')
              : 'No languages available';
          capital = data[0]['capital'] != null ? data[0]['capital'][0] : 'No capital available';
          currencies = data[0]['currencies'] != null
              ? data[0]['currencies'].keys.join(', ')
              : 'No currencies available';
          borders = data[0]['borders'] != null && data[0]['borders'].isNotEmpty
              ? data[0]['borders'].join(', ')
              : 'No borders available';
        });
      } else {
        setState(() {
          countryName = 'No data available';
          region = '';
          languages = '';
          capital = '';
          currencies = '';
          borders = '';
        });
      }
    } else {
      // Handle errors
      setState(() {
        countryName = 'Failed to load data. Error: ${response.statusCode}';
        region = '';
        languages = '';
        capital = '';
        currencies = '';
        borders = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _countryController.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Country Info')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input field for country name
              TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Enter country name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Button to fetch country data
              ElevatedButton(
                onPressed: () {
                  // Fetch data when the button is pressed
                  String country = _countryController.text.trim();
                  if (country.isNotEmpty) {
                    fetchData(country);
                  } else {
                    setState(() {
                      countryName = 'Please enter a valid country name';
                    });
                  }
                },
                child: Text('Search'),
              ),
              SizedBox(height: 20),
              // Display country information
              Text(
                'Country: $countryName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Region: $region'),
              SizedBox(height: 10),
              Text('Languages: $languages'),
              SizedBox(height: 10),
              Text('Capital: $capital'),
              SizedBox(height: 10),
              Text('Currencies: $currencies'),
              SizedBox(height: 10),
              Text('Borders: $borders'),
            ],
          ),
        ),
      ),
    );
  }
}

