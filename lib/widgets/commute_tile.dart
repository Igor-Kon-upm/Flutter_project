import 'package:flutter/material.dart';
import '../models/commute_model.dart';
import 'package:intl/intl.dart';

class CommuteTile extends StatelessWidget {
  final CommuteModel commute;

  const CommuteTile({super.key, required this.commute});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () => _showDetails(context),
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(commute.type),
          child: Icon(_getTypeIcon(commute.type), color: Colors.white),
        ),
        title: Text('${commute.typeName} - ${commute.distanceKm} km'),
        subtitle: Text(DateFormat('MMM d, h:mm a').format(commute.timestamp)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${commute.points} pts',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text(
              '${commute.co2SavedKg} kg CO2',
              style: TextStyle(
                fontSize: 12,
                color: commute.co2SavedKg >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24.0,
            left: 24.0,
            right: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getTypeIcon(commute.type), size: 48, color: _getTypeColor(commute.type)),
                const SizedBox(height: 16),
                Text(
                  '${commute.typeName} Details',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 32),
                _buildDetailRow(Icons.straighten, 'Distance', '${commute.distanceKm} km'),
                _buildDetailRow(Icons.timer, 'Duration', '${commute.durationMinutes} min'),
                if (commute.type != CommuteType.car) ...[
                  _buildDetailRow(Icons.speed, 'Average Pace', '${commute.pace} min/km'),
                  _buildDetailRow(Icons.local_fire_department, 'Calories Burned', '${commute.caloriesBurned} kcal'),
                ],
                _buildDetailRow(Icons.eco, 'CO2 Saved', '${commute.co2SavedKg} kg'),
                _buildDetailRow(Icons.star, 'Points Earned', '${commute.points} pts'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  IconData _getTypeIcon(CommuteType type) {
    switch (type) {
      case CommuteType.walking:
        return Icons.directions_walk;
      case CommuteType.cycling:
        return Icons.directions_bike;
      case CommuteType.car:
        return Icons.directions_car;
    }
  }

  Color _getTypeColor(CommuteType type) {
    switch (type) {
      case CommuteType.walking:
        return Colors.blue;
      case CommuteType.cycling:
        return Colors.orange;
      case CommuteType.car:
        return Colors.grey;
    }
  }
}
