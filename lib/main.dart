import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'models/commute_model.dart';
import 'services/mock_data_service.dart';
import 'services/air_quality_service.dart';
import 'widgets/commute_tile.dart';

void main() {
  runApp(const GreenTrackApp());
}

class GreenTrackApp extends StatelessWidget {
  const GreenTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MockDataService _dataService = MockDataService();
  final AirQualityService _airService = AirQualityService();
  late ConfettiController _confettiController;
  List<CommuteModel> _commutes = [];
  bool _isLoading = true;
  bool _isSimulating = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadInitialData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// Loads data from SharedPreferences or mock if empty.
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? commutesJson = prefs.getString('commutes');
    
    if (commutesJson != null) {
      final List<dynamic> decoded = json.decode(commutesJson);
      setState(() {
        _commutes = decoded.map((item) => CommuteModel.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      final commutes = await _dataService.getMockCommutes();
      setState(() {
        _commutes = commutes;
        _isLoading = false;
      });
      _saveCommutes();
    }
  }

  Future<void> _saveCommutes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_commutes.map((c) => c.toJson()).toList());
    await prefs.setString('commutes', encoded);
  }

  /// Triggers a commute simulation with AQI multipliers.
  Future<void> _simulateNewCommute() async {
    setState(() {
      _isSimulating = true;
    });

    try {
      // Get random city AQI for multiplier
      final airData = await _airService.getSpainAirQuality();
      double multiplier = 1.0;
      String? cityName;
      
      if (airData.isNotEmpty) {
        final randomCity = airData[DateTime.now().millisecond % airData.length];
        multiplier = _airService.getMultiplier(randomCity['aqi']);
        cityName = randomCity['name'];
      }

      final newCommute = await _dataService.simulateCommute(multiplier: multiplier);
      
      // Check for goal completion (100 pts) before updating state
      int oldTotal = _totalPoints;
      
      setState(() {
        _commutes.insert(0, newCommute);
        _isSimulating = false;
      });
      _saveCommutes();

      if (!mounted) return;

      if ((oldTotal % 100) + newCommute.points >= 100) {
         _confettiController.play();
      }
      
      String message = 'New Commute: ${newCommute.typeName} - ${newCommute.points} pts earned!';
      if (multiplier > 1.0) {
        message += ' (${multiplier}x bonus for AQI in $cityName!)';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: multiplier > 1.0 ? Colors.orange : Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      setState(() {
        _isSimulating = false;
      });
    }
  }

  int get _totalPoints => _commutes.fold(0, (sum, item) => sum + item.points);
  double get _totalCo2Saved => _commutes.fold(0.0, (sum, item) => sum + item.co2SavedKg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenTrack Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.air),
            onPressed: () => _showAirQuality(context),
            tooltip: 'Spain Air Quality',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showTrainingSummary(context),
            tooltip: 'Training Summary',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => _showAchievements(context),
            tooltip: 'Achievements',
          ),
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => _showLeaderboard(context),
            tooltip: 'Leaderboard',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    _buildPointsHeader(),
                    const Divider(height: 1),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: _commutes.length,
                            itemBuilder: (context, index) {
                              return CommuteTile(commute: _commutes[index]);
                            },
                          ),
                          if (_isSimulating)
                            Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Simulating Commute...'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSimulating ? null : _simulateNewCommute,
        label: const Text('Start Commute'),
        icon: const Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildPointsHeader() {
    const int dailyGoal = 100;
    double progress = (_totalPoints % dailyGoal) / dailyGoal;
    if (_totalPoints > 0 && _totalPoints % dailyGoal == 0) progress = 1.0;
    
    double treesSaved = _totalCo2Saved / 2.0;
    if (treesSaved < 0) treesSaved = 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Total Eco-Points', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Text('$_totalPoints', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Trees Saved', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Text(treesSaved.toStringAsFixed(1), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(width: 4),
                      const Icon(Icons.park, color: Colors.green, size: 28),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Goal: ${(_totalPoints % dailyGoal).toInt()}/$dailyGoal pts', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            ],
          ),
        ],
      ),
    );
  }

  void _showTrainingSummary(BuildContext context) {
    final trainingCommutes = _commutes.where((c) => c.type != CommuteType.car).toList();
    double totalKm = trainingCommutes.fold(0.0, (sum, item) => sum + item.distanceKm);
    int totalMinutes = trainingCommutes.fold(0, (sum, item) => sum + item.durationMinutes);
    int totalCalories = trainingCommutes.fold(0, (sum, item) => sum + item.caloriesBurned);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(children: [Icon(Icons.bar_chart, color: Colors.green, size: 28), SizedBox(width: 12), Text('Training Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))]),
            const Divider(height: 32),
            _buildSummaryStat(Icons.numbers, 'Total Workouts', '${trainingCommutes.length}'),
            _buildSummaryStat(Icons.straighten, 'Total Distance', '${totalKm.toStringAsFixed(2)} km'),
            _buildSummaryStat(Icons.timer, 'Total Time', '$totalMinutes min'),
            _buildSummaryStat(Icons.local_fire_department, 'Total Calories', '$totalCalories kcal'),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), onPressed: () => Navigator.pop(context), child: const Text('Great Job!'))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  void _showAirQuality(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FutureBuilder<List<Map<String, dynamic>>>(
        future: _airService.getSpainAirQuality(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
          if (snapshot.hasError || !snapshot.hasData) return const SizedBox(height: 200, child: Center(child: Text('Error loading data')));
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Live Air Quality (Spain)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('European AQI Index', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final city = data[index];
                      return ListTile(
                        leading: _getAqiIcon(city['aqi']),
                        title: Text(city['name']),
                        subtitle: Text('Status: ${city['status']}'),
                        trailing: Text('AQI: ${city['aqi']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getAqiIcon(int aqi) {
    Color color = aqi <= 20 ? Colors.green : aqi <= 40 ? Colors.lightGreen : aqi <= 60 ? Colors.yellow[700]! : aqi <= 80 ? Colors.orange : Colors.red;
    return Icon(Icons.cloud, color: color);
  }

  void _showAchievements(BuildContext context) {
    final achievements = _dataService.getAchievements();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Achievements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final a = achievements[index];
                  final unlocked = a['isUnlocked'] as bool;
                  return ListTile(
                    leading: Text(a['icon'], style: TextStyle(fontSize: 32, color: unlocked ? null : Colors.grey)),
                    title: Text(a['title'], style: TextStyle(fontWeight: FontWeight.bold, color: unlocked ? Colors.black : Colors.grey)),
                    subtitle: Text(a['description']),
                    trailing: Icon(unlocked ? Icons.check_circle : Icons.lock, color: unlocked ? Colors.green : Colors.grey),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaderboard(BuildContext context) {
    final allLeaderboards = _dataService.getLeaderboards();
    final categories = allLeaderboards.keys.toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DefaultTabController(
        length: categories.length,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
          builder: (context, scrollController) => Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const Padding(padding: EdgeInsets.all(16.0), child: Text('Eco Leaderboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              TabBar(tabs: categories.map((cat) => Tab(text: cat)).toList(), labelColor: Colors.green, indicatorColor: Colors.green),
              Expanded(
                child: TabBarView(
                  children: categories.map((cat) {
                    final users = allLeaderboards[cat]!;
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final u = users[index];
                        final isMe = u['name'] == 'You';
                        return ListTile(
                          leading: CircleAvatar(backgroundColor: isMe ? Colors.green : Colors.grey[200], child: Text(u['name'][0], style: TextStyle(color: isMe ? Colors.white : Colors.black))),
                          title: Text(u['name'], style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal)),
                          trailing: Text('${u['points']} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
