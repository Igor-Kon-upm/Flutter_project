import 'dart:math';
import '../models/commute_model.dart';

class MockDataService {
  final Random _random = Random();

  /// Returns a list of 5 hardcoded trips.
  Future<List<CommuteModel>> getMockCommutes() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      CommuteModel(
        id: '1',
        type: CommuteType.walking,
        distanceKm: 2.5,
        co2SavedKg: 0.5,
        points: 25,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        durationMinutes: 30,
      ),
      CommuteModel(
        id: '2',
        type: CommuteType.cycling,
        distanceKm: 5.0,
        co2SavedKg: 1.0,
        points: 50,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        durationMinutes: 20,
      ),
      CommuteModel(
        id: '3',
        type: CommuteType.car,
        distanceKm: 15.0,
        co2SavedKg: -3.0,
        points: 5,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 25,
      ),
      CommuteModel(
        id: '4',
        type: CommuteType.cycling,
        distanceKm: 8.0,
        co2SavedKg: 1.6,
        points: 80,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        durationMinutes: 35,
      ),
      CommuteModel(
        id: '5',
        type: CommuteType.walking,
        distanceKm: 1.2,
        co2SavedKg: 0.24,
        points: 12,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        durationMinutes: 15,
      ),
    ];
  }

  /// Simulates a commute and returns a new CommuteModel.
  Future<CommuteModel> simulateCommute({double multiplier = 1.0}) async {
    await Future.delayed(const Duration(seconds: 2));

    final types = CommuteType.values;
    final type = types[_random.nextInt(types.length)];
    final distance = _random.nextDouble() * 10 + 1;
    
    double co2Saved;
    int points;
    int duration;

    switch (type) {
      case CommuteType.walking:
        co2Saved = distance * 0.2;
        points = (distance * 10 * multiplier).round();
        duration = (distance * 12).round(); // ~12 min/km
        break;
      case CommuteType.cycling:
        co2Saved = distance * 0.2;
        points = (distance * 10 * multiplier).round();
        duration = (distance * 4).round(); // ~4 min/km
        break;
      case CommuteType.car:
        co2Saved = -distance * 0.2;
        points = 5;
        duration = (distance * 2).round(); // ~2 min/km
        break;
    }

    return CommuteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      distanceKm: double.parse(distance.toStringAsFixed(2)),
      co2SavedKg: double.parse(co2Saved.toStringAsFixed(2)),
      points: points,
      timestamp: DateTime.now(),
      durationMinutes: duration,
    );
  }

  /// Returns mock users for different timeframes.
  Map<String, List<Map<String, dynamic>>> getLeaderboards() {
    return {
      'Daily': [
        {'name': 'SpeedyBike', 'points': 150},
        {'name': 'EcoWalker', 'points': 142},
        {'name': 'GreenFoot', 'points': 125},
        {'name': 'CarbonCutter', 'points': 118},
        {'name': 'WindRider', 'points': 110},
        {'name': 'SolarPath', 'points': 95},
        {'name': 'LeafHopper', 'points': 88},
        {'name': 'EarthBound', 'points': 75},
        {'name': 'NatureBoy', 'points': 68},
        {'name': 'You', 'points': 45},
        {'name': 'CityCyclist', 'points': 42},
        {'name': 'EcoRunner', 'points': 38},
        {'name': 'GreenWave', 'points': 30},
        {'name': 'PureAir', 'points': 25},
        {'name': 'StepMaster', 'points': 12},
      ],
      'Weekly': [
        {'name': 'EcoWarrior', 'points': 1250},
        {'name': 'BikeLover', 'points': 1120},
        {'name': 'GreenTraveler', 'points': 980},
        {'name': 'EarthFriend', 'points': 950},
        {'name': 'SustainabilityKing', 'points': 880},
        {'name': 'OxygenGenerator', 'points': 820},
        {'name': 'WindWalker', 'points': 750},
        {'name': 'SolarPowered', 'points': 710},
        {'name': 'RecyclePro', 'points': 690},
        {'name': 'GaiaGuardian', 'points': 650},
        {'name': 'CleanCity', 'points': 610},
        {'name': 'EcoVibe', 'points': 580},
        {'name': 'TrailBlazer', 'points': 520},
        {'name': 'ZeroWaste', 'points': 490},
        {'name': 'You', 'points': 320},
        {'name': 'ForestSpirit', 'points': 280},
        {'name': 'RiverKeeper', 'points': 250},
        {'name': 'SkyWatcher', 'points': 150},
      ],
      'Monthly': [
        {'name': 'EcoWarrior', 'points': 5250},
        {'name': 'GreenTraveler', 'points': 4980},
        {'name': 'BikeLover', 'points': 4850},
        {'name': 'NatureFriend', 'points': 4720},
        {'name': 'ForestGuardian', 'points': 4500},
        {'name': 'PlanetFirst', 'points': 4300},
        {'name': 'ClimateAction', 'points': 4100},
        {'name': 'EarthPreserve', 'points': 3800},
        {'name': 'BioSphere', 'points': 3600},
        {'name': 'GreenTech', 'points': 3400},
        {'name': 'EcoLife', 'points': 3200},
        {'name': 'WildHeart', 'points': 3000},
        {'name': 'SeaChange', 'points': 2800},
        {'name': 'MountainHigh', 'points': 2600},
        {'name': 'ValleyGreen', 'points': 2400},
        {'name': 'PureFlow', 'points': 2200},
        {'name': 'SunRay', 'points': 2000},
        {'name': 'CloudNine', 'points': 1800},
        {'name': 'EcoZen', 'points': 1600},
        {'name': 'You', 'points': 1200},
        {'name': 'GreenSpirit', 'points': 1100},
        {'name': 'EcoNomad', 'points': 950},
        {'name': 'CleanAir', 'points': 800},
        {'name': 'BlueSky', 'points': 700},
      ],
    };
  }

  /// Returns a larger list of mock achievements.
  List<Map<String, dynamic>> getAchievements() {
    return [
      {
        'title': 'Eco-Walker',
        'description': 'Walked more than 5km total.',
        'icon': '🚶',
        'isUnlocked': true,
      },
      {
        'title': 'Cyclist Pro',
        'description': 'Completed 10 cycling trips.',
        'icon': '🚴',
        'isUnlocked': false,
      },
      {
        'title': 'CO2 Hero',
        'description': 'Saved 10kg of CO2.',
        'icon': '🌳',
        'isUnlocked': true,
      },
      {
        'title': 'Early Bird',
        'description': 'Commute before 7:00 AM.',
        'icon': '🌅',
        'isUnlocked': true,
      },
      {
        'title': 'Century Club',
        'description': 'Reach 100 points in one day.',
        'icon': '💯',
        'isUnlocked': false,
      },
      {
        'title': 'Rainy Day Warrior',
        'description': 'Commute in bad weather.',
        'icon': '🌧️',
        'isUnlocked': false,
      },
      {
        'title': 'Green Streak',
        'description': '7 days of eco-friendly travel.',
        'icon': '🔥',
        'isUnlocked': false,
      },
      {
        'title': 'Tree Planter',
        'description': 'Save enough CO2 to plant 5 trees.',
        'icon': '🌲',
        'isUnlocked': true,
      },
      {
        'title': 'Urban Explorer',
        'description': 'Visit 5 different districts.',
        'icon': '🏙️',
        'isUnlocked': false,
      },
      {
        'title': 'Zero Emissions',
        'description': 'A week without car commutes.',
        'icon': '🚲',
        'isUnlocked': true,
      },
      {
        'title': 'Marathon Man',
        'description': 'Total distance of 42.2 km.',
        'icon': '🏁',
        'isUnlocked': false,
      },
      {
        'title': 'Night Owl',
        'description': 'Commute after 10:00 PM.',
        'icon': '🌙',
        'isUnlocked': true,
      },
      {
        'title': 'Mountain Climber',
        'description': 'Complete a trip with elevation.',
        'icon': '⛰️',
        'isUnlocked': false,
      },
      {
        'title': 'Ocean Protector',
        'description': 'Saved 50kg of CO2 total.',
        'icon': '🌊',
        'isUnlocked': false,
      },
      {
        'title': 'Social Butterfly',
        'description': 'Invite 3 friends to GreenTrack.',
        'icon': '🦋',
        'isUnlocked': false,
      },
      {
        'title': 'Efficiency Master',
        'description': 'Average 15 points per km.',
        'icon': '⚡',
        'isUnlocked': true,
      },
      {
        'title': 'Weekend Warrior',
        'description': 'Commute on Saturday and Sunday.',
        'icon': '🎉',
        'isUnlocked': false,
      },
      {
        'title': 'Spring Breeze',
        'description': 'First commute in Spring.',
        'icon': '🌸',
        'isUnlocked': true,
      },
      {
        'title': 'Summer Heat',
        'description': 'Commute when it\'s over 30°C.',
        'icon': '☀️',
        'isUnlocked': false,
      },
      {
        'title': 'Winter Frost',
        'description': 'Commute when it\'s below 0°C.',
        'icon': '❄️',
        'isUnlocked': false,
      },
      {
        'title': 'Sustainability Guru',
        'description': 'Unlock all basic achievements.',
        'icon': '🧘',
        'isUnlocked': false,
      },
      {
        'title': 'Public Transport Fan',
        'description': 'Use a bus or train (simulated).',
        'icon': '🚌',
        'isUnlocked': true,
      },
      {
        'title': 'Green Architect',
        'description': 'Reach Level 10.',
        'icon': '🏗️',
        'isUnlocked': false,
      },
      {
        'title': 'Earth Day Hero',
        'description': 'Log a trip on April 22nd.',
        'icon': '🌍',
        'isUnlocked': false,
      },
    ];
  }
}
