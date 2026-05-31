enum CommuteType { walking, cycling, car }

class CommuteModel {
  final String id;
  final CommuteType type;
  final double distanceKm;
  final double co2SavedKg;
  final int points;
  final DateTime timestamp;
  final int durationMinutes; // New field

  CommuteModel({
    required this.id,
    required this.type,
    required this.distanceKm,
    required this.co2SavedKg,
    required this.points,
    required this.timestamp,
    required this.durationMinutes,
  });

  String get typeName {
    switch (type) {
      case CommuteType.walking:
        return 'Walking';
      case CommuteType.cycling:
        return 'Cycling';
      case CommuteType.car:
        return 'Car';
    }
  }

  /// Calculates burned calories based on type and distance.
  int get caloriesBurned {
    switch (type) {
      case CommuteType.walking:
        return (distanceKm * 50).round(); // ~50 kcal/km
      case CommuteType.cycling:
        return (distanceKm * 30).round(); // ~30 kcal/km
      case CommuteType.car:
        return 0;
    }
  }

  /// Returns pace in min/km.
  String get pace {
    if (distanceKm == 0) return '0:00';
    double paceDecimal = durationMinutes / distanceKm;
    int minutes = paceDecimal.floor();
    int seconds = ((paceDecimal - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'distanceKm': distanceKm,
      'co2SavedKg': co2SavedKg,
      'points': points,
      'timestamp': timestamp.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }

  factory CommuteModel.fromJson(Map<String, dynamic> json) {
    return CommuteModel(
      id: json['id'],
      type: CommuteType.values[json['type']],
      distanceKm: json['distanceKm'],
      co2SavedKg: json['co2SavedKg'],
      points: json['points'],
      timestamp: DateTime.parse(json['timestamp']),
      durationMinutes: json['durationMinutes'],
    );
  }
}
