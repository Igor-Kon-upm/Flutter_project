# GreenTrack App

## Description

This application is a Flutter-based mobile app designed to gamify eco-friendly commuting. The goal is to encourage users to choose walking or cycling over driving by providing real-time incentives, social competition, and detailed activity tracking while providing an engaging experience.

It enhances the user experience by offering dynamic point multipliers based on live air quality data — rewarding users for choosing sustainable transport in areas with higher pollution — making the environmental impact tangible. Unlike generic fitness apps, this app focuses specifically on ecological metrics and global sustainability, providing a niche experience for environmentally conscious users.

## Screenshots and Navigation

<p align="center">
  <img src="screens/1.png" width="250" title="Dashboard">
  <img src="screens/2.png" width="250" title="Dashboard">
  <img src="screens/3.png" width="250" title="Dashboard">
  <img src="screens/4.png" width="250" title="Dashboard">
  <img src="screens/5.png" width="250" title="Dashboard">
  <img src="screens/6.png" width="250" title="Dashboard">
  <img src="screens/7.png" width="250" title="Dashboard">
  <img src="screens/8.png" width="250" title="Dashboard">
</p>

## Demo Video

[![GreenTrack Demo](https://img.youtube.com/vi/TWÓJ_ID_FILMU/0.jpg)](https://www.youtube.com/watch?v=TWÓJ_ID_FILMU)

*Click the image above to watch the demo on YouTube.*

## Functional Features

* **Eco-Points Tracking:** Earn points for every sustainable trip you take.
* **Environmental Impact:** Visual feedback on "Trees Saved" based on CO2 reduction metrics.
* **Daily Goals:** A 100-point daily goal system with visual progress tracking.
* **Real-time AQI Integration:** Live data from Open-Meteo API providing bonuses for commuting in polluted cities.
* **Leaderboard System:** Competitive rankings across Daily, Weekly, and Monthly tabs.
* **Achievements System:** 24+ unlockable badges for reaching specific eco-milestones.

## Technical Features

* **Architecture:** Stateful Dashboard architecture for real-time UI updates.
* **UI Framework:** Built entirely with Flutter and Material Design 3.
* **Persistence:** `SharedPreferences` for local storage of commutes and user progress.
* **API Integration:** `http` package for fetching live European AQI data.
* **Visual Rewards:** `confetti` package for celebrating goal completions.
* **Language:** 100% Dart.

## How to Use

1. **Launch the App:** Open the GreenTrack app on your mobile device.
2. **Dashboard Overview:** Check your current Eco-Points, Trees Saved, and Daily Goal progress.
3. **Start Commute:** Tap the "Start Commute" button to simulate a new eco-friendly trip.
4. **View Activity Details:** Click on any commute in the list to see detailed stats like calories, pace, and CO2 saved.
5. **Explore Features:** Access Air Quality stats, Training Summaries, Achievements, or the Leaderboard via the top-right corner icons.
6. **Achieve Goals:** Reach 100 points to trigger the reward animation and fill your daily progress.

## Participants

**MAD Developers:**

* **[Igor Kondrat]** (i.kondrat@alumnos.upm.es)
* **[Silvana Dimitrova]** (silvana.dimitrova@alumnos.upm.es)

**Workload distribution:** (50%/50%)
