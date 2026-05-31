import 'dart:convert';
import 'package:http/http.dart' as http;

class AirQualityService {
  final List<Map<String, dynamic>> cities = [
    {'name': 'Madrid', 'lat': 40.4165, 'lon': -3.7026},
    {'name': 'Barcelona', 'lat': 41.3888, 'lon': 2.159},
    {'name': 'Valencia', 'lat': 39.4697, 'lon': -0.3774},
    {'name': 'Seville', 'lat': 37.3828, 'lon': -5.9732},
    {'name': 'Zaragoza', 'lat': 41.6488, 'lon': -0.8891},
    {'name': 'Málaga', 'lat': 36.7213, 'lon': -4.4214},
    {'name': 'Murcia', 'lat': 37.9922, 'lon': -1.1307},
    {'name': 'Palma', 'lat': 39.5696, 'lon': 2.6502},
    {'name': 'Las Palmas', 'lat': 28.1235, 'lon': -15.4363},
    {'name': 'Bilbao', 'lat': 43.2630, 'lon': -2.9350},
    {'name': 'Alicante', 'lat': 38.3452, 'lon': -0.4815},
    {'name': 'Córdoba', 'lat': 37.8882, 'lon': -4.7794},
    {'name': 'Valladolid', 'lat': 41.6523, 'lon': -4.7245},
    {'name': 'Vigo', 'lat': 42.2406, 'lon': -8.7207},
    {'name': 'Gijón', 'lat': 43.5357, 'lon': -5.6615},
    {'name': 'L\'Hospitalet', 'lat': 41.3597, 'lon': 2.1003},
    {'name': 'Vitoria-Gasteiz', 'lat': 42.8467, 'lon': -2.6716},
    {'name': 'A Coruña', 'lat': 43.3623, 'lon': -8.4115},
    {'name': 'Granada', 'lat': 37.1773, 'lon': -3.5986},
    {'name': 'Elche', 'lat': 38.2669, 'lon': -0.6983},
    {'name': 'Oviedo', 'lat': 43.3603, 'lon': -5.8448},
    {'name': 'Terrassa', 'lat': 41.5611, 'lon': 2.0081},
    {'name': 'Badalona', 'lat': 41.4500, 'lon': 2.2475},
    {'name': 'Cartagena', 'lat': 37.6051, 'lon': -0.9862},
    {'name': 'Jerez de la Frontera', 'lat': 36.6850, 'lon': -6.1261},
    {'name': 'Sabadell', 'lat': 41.5463, 'lon': 2.1086},
    {'name': 'Móstoles', 'lat': 40.3223, 'lon': -3.8649},
    {'name': 'Santa Cruz de Tenerife', 'lat': 28.4636, 'lon': -16.2518},
    {'name': 'Pamplona', 'lat': 42.8125, 'lon': -1.6458},
    {'name': 'Almería', 'lat': 36.8340, 'lon': -2.4637},
    {'name': 'Alcalá de Henares', 'lat': 40.4819, 'lon': -3.3635},
    {'name': 'Fuenlabrada', 'lat': 40.2842, 'lon': -3.7942},
    {'name': 'Leganés', 'lat': 40.3275, 'lon': -3.7635},
    {'name': 'Donostia-San Sebastián', 'lat': 43.3183, 'lon': -1.9812},
    {'name': 'Getafe', 'lat': 40.3083, 'lon': -3.7328},
    {'name': 'Burgos', 'lat': 42.3439, 'lon': -3.6969},
    {'name': 'Albacete', 'lat': 38.9943, 'lon': -1.8585},
    {'name': 'Castellón de la Plana', 'lat': 39.9864, 'lon': -0.0513},
    {'name': 'Santander', 'lat': 43.4623, 'lon': -3.8099},
    {'name': 'Alcorcón', 'lat': 40.3458, 'lon': -3.8249},
    {'name': 'San Cristóbal de La Laguna', 'lat': 28.4853, 'lon': -16.3150},
    {'name': 'Logroño', 'lat': 42.4627, 'lon': -2.4450},
    {'name': 'Badajoz', 'lat': 38.8794, 'lon': -6.9707},
    {'name': 'Huelva', 'lat': 37.2583, 'lon': -6.9508},
    {'name': 'Salamanca', 'lat': 40.9701, 'lon': -5.6635},
    {'name': 'Marbella', 'lat': 36.5100, 'lon': -4.8824},
    {'name': 'Lleida', 'lat': 41.6176, 'lon': 0.6200},
    {'name': 'Tarragona', 'lat': 41.1189, 'lon': 1.2445},
    {'name': 'Dos Hermanas', 'lat': 37.2828, 'lon': -5.9200},
    {'name': 'Torrejón de Ardoz', 'lat': 40.4561, 'lon': -3.4786},
  ];

  Future<List<Map<String, dynamic>>> getSpainAirQuality() async {
    List<Map<String, dynamic>> results = [];

    for (var city in cities) {
      try {
        final url = Uri.parse(
            'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${city['lat']}&longitude=${city['lon']}&current=european_aqi');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          results.add({
            'name': city['name'],
            'aqi': data['current']['european_aqi'],
            'status': _getAqiStatus(data['current']['european_aqi']),
          });
        }
      } catch (e) {
        print('Error fetching air quality for ${city['name']}: $e');
      }
    }
    return results;
  }

  String _getAqiStatus(int aqi) {
    if (aqi <= 20) return 'Great';
    if (aqi <= 40) return 'Fair';
    if (aqi <= 60) return 'Moderate';
    if (aqi <= 80) return 'Poor';
    if (aqi <= 100) return 'Very Poor';
    return 'Extremely Poor';
  }

  double getMultiplier(int aqi) {
    if (aqi <= 20) return 1.0;
    if (aqi <= 40) return 1.1;
    if (aqi <= 60) return 1.3;
    if (aqi <= 80) return 1.6;
    if (aqi <= 100) return 2.0;
    return 2.5;
  }
}
