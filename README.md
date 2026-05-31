# GreenTrack 🌿

GreenTrack is a Flutter-based mobile application designed to gamify eco-friendly commuting. It encourages users to choose walking or cycling over driving by providing real-time incentives, social competition, and detailed activity tracking.

## 🚀 Features

### 1. Interactive Dashboard
- **Eco-Points Tracking:** Earn points for every sustainable trip you take.
- **Environmental Impact:** See your contribution in "Trees Saved" (based on 2kg of CO2 saved per tree impact).
- **Daily Goals:** A 100-point daily goal with a visual progress bar and reward system.

### 2. Commute Simulation
- **Multi-modal Tracking:** Support for Walking, Cycling, and Car commutes.
- **Detailed Metrics:** Automatically calculates:
  - Distance (km)
  - CO2 Saved (kg)
  - Calories Burned (based on activity type)
  - Pace (min/km)
  - Duration

### 3. Real-time Air Quality (AQI) Integration
- **Live Data:** Fetches European AQI data for 50 Spanish cities using the Open-Meteo API.
- **Dynamic Multipliers:** Earn bonus points (up to 2.5x) for cycling or walking in cities with poor air quality—rewarding your "heroic" effort to reduce pollution where it matters most.

### 4. Gamification & Rewards
- **Achievements:** Over 24 unique badges to unlock (e.g., "CO2 Hero", "Early Bird", "Marathon Man").
- **Leaderboards:** Competitive rankings across Daily, Weekly, and Monthly tabs with 50+ mock entries.
- **Visual Feedback:** Confetti celebrations upon reaching your daily goal.

### 5. Training Summary
- Aggregate statistics for all walking and cycling activities.
- View total workouts, total distance covered, total time spent, and total calories burned.

### 6. Data Persistence
- Uses `shared_preferences` to ensure your commute history and total points are saved locally on your device.

## 🛠️ Tech Stack

- **Framework:** Flutter (Material 3)
- **Language:** Dart
- **API:** [Open-Meteo Air Quality API](https://open-meteo.com/en/docs/air-quality-api)
- **Key Packages:**
  - `http`: For API requests.
  - `shared_preferences`: For local data storage.
  - `confetti`: For goal completion animations.
  - `intl`: For date and number formatting.

## 📦 Installation

1. **Prerequisites:**
   - Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed.
   - **Important for Windows Users:** Enable **Developer Mode** in your Windows System Settings to allow the creation of symbolic links required by Flutter plugins.

2. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/greentrack.git
   cd greentrack
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📉 Metrics Logic

- **CO2 Calculation:**
  - Walking/Cycling: +0.2kg saved per km.
  - Car: -0.2kg impact per km.
- **Points:** Base points are calculated by distance, modified by the city's Air Quality multiplier at the time of the trip.
- **Trees Saved:** 1 "Tree Saved" unit = 2kg of CO2 offset.

## 🛤️ Roadmap
- [ ] Integration with Google Maps for real GPS tracking.
- [ ] Social features: Add friends and share achievements.
- [ ] Monthly eco-reports exported to PDF.
- [ ] Support for public transport (Bus/Train) with specific CO2 metrics.

---
*Created as part of an eco-friendly initiatives simulation project.*
