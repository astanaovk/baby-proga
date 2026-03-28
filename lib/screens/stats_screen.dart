import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/data_service.dart';
import '../services/l10n_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String _formatSleep(int minutes, L10nService l10n) {
    if (minutes == 0) return '0${l10n.t('minutes')}';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final hk = l10n.t('hours');
    final mk = l10n.t('minutes');
    return h > 0 ? '${h}$hk${m}$mk' : '${m}$mk';
  }

  String _formatInterval(int minutes, L10nService l10n) {
    if (minutes < 60) return '$minutes${l10n.t('minutes')}';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}${l10n.t('hours')}${m}${l10n.t('minutes')}';
  }

  List<Map> _getWeekData(DataService ds, String type, L10nService l10n) {
    final now = DateTime.now();
    final result = <Map>[];
    final weekdays = [
      l10n.t('mon'), l10n.t('tue'), l10n.t('wed'),
      l10n.t('thu'), l10n.t('fri'), l10n.t('sat'), l10n.t('sun'),
    ];
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      int count = 0;
      if (type == 'feeding') {
        count = ds.feedingRecords.where((r) => r.time.year == d.year && r.time.month == d.month && r.time.day == d.day).length;
      } else {
        count = ds.diaperRecords.where((r) => r.time.year == d.year && r.time.month == d.month && r.time.day == d.day).length;
      }
      result.add({'label': weekdays[d.weekday % 7], 'count': count, 'date': d});
    }
    return result;
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMergedSection(List<Map<String, dynamic>> merged, L10nService l10n) {
    if (merged.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('merged_events'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text('${l10n.t('merge_hint')}: 10${l10n.t('minutes')}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: merged.take(10).map((item) {
                final time = item['time'] as DateTime;
                final type = item['type'] as String;
                final events = item['events'] as List?;
                final count = events != null ? events.length + 1 : 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(type == 'feeding' ? Icons.local_drink : Icons.baby_changing_station,
                          color: type == 'feeding' ? Colors.blue : Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
                      const SizedBox(width: 8),
                      Text('$count${l10n.t('times2')}', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIntervalSection(List<Map<String, dynamic>> intervals, String type, L10nService l10n) {
    if (intervals.isEmpty) return const SizedBox.shrink();
    final iconColor = type == 'feeding' ? Colors.blue : Colors.orange;
    final avg = intervals.isEmpty ? 0 : intervals.map((e) => e['minutes'] as int).reduce((a, b) => a + b) ~/ intervals.length;
    final minVal = intervals.isEmpty ? 0 : intervals.map((e) => e['minutes'] as int).reduce((a, b) => a < b ? a : b);
    final maxVal = intervals.isEmpty ? 0 : intervals.map((e) => e['minutes'] as int).reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type == 'feeding' ? l10n.t('feeding_interval') : l10n.t('diaper_interval'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _statCard(l10n.t('avg_interval'), _formatInterval(avg, l10n), Icons.timelapse, iconColor),
                _statCard(l10n.t('min_interval'), _formatInterval(minVal, l10n), Icons.speed, Colors.green),
                _statCard(l10n.t('max_interval'), _formatInterval(maxVal, l10n), Icons.slow_motion_video, Colors.red),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final l10n = context.watch<L10nService>();
    final merged = ds.getMergedRecords();
    final feedingIntervals = ds.getIntervals('feeding');
    final diaperIntervals = ds.getIntervals('diaper');
    final freqStats = ds.getFrequencyStats();
    final stats = ds.todayStats();
    final weekFeedings = _getWeekData(ds, 'feeding', l10n);
    final weekDiapers = _getWeekData(ds, 'diaper', l10n);

    final feedingCount = stats['feedingCount'] ?? 0;
    final totalBottleMl = stats['totalBottleMl'] ?? 0;
    final diaperCount = stats['diaperCount'] ?? 0;
    final peeCount = stats['peeCount'] ?? 0;
    final poopCount = stats['poopCount'] ?? 0;
    final totalSleepMinutes = stats['totalSleepMinutes'] ?? 0;
    final totalBreastMinutes = stats['totalBreastMinutes'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('stats_title')), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 今日概况
          Text(l10n.t('today_overview'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _statCard(l10n.t('feeding_times'), '$feedingCount${l10n.t('times2')}', Icons.local_drink, Colors.blue),
                      _statCard(l10n.t('total_milk'), '${totalBottleMl}ml', Icons.water_drop, Colors.cyan),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statCard(l10n.t('diaper_count'), '$diaperCount${l10n.t('times2')}', Icons.baby_changing_station, Colors.orange),
                      _statCard(l10n.t('diaper_detail'), '$peeCount/$poopCount', Icons.show_chart, Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statCard(l10n.t('sleep_duration2'), _formatSleep(totalSleepMinutes, l10n), Icons.bedtime, Colors.purple),
                      _statCard(l10n.t('breast_duration'), '$totalBreastMinutes${l10n.t('minutes')}', Icons.child_care, Colors.pink),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 合并事件
          _buildMergedSection(merged, l10n),

          // 喂奶间隔
          _buildIntervalSection(feedingIntervals, 'feeding', l10n),

          // 换尿布间隔
          _buildIntervalSection(diaperIntervals, 'diaper', l10n),

          // 本周频次
          Text(l10n.t('weekly_frequency'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _statCard(l10n.t('avg_per_day'), '${freqStats['avgFeedingPerDay']}${l10n.t('times2')}', Icons.local_drink, Colors.blue),
                      _statCard(l10n.t('total_this_week'), '${freqStats['totalFeeding']}${l10n.t('times2')}', Icons.calendar_today, Colors.cyan),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statCard(l10n.t('avg_per_day'), '${freqStats['avgDiaperPerDay']}${l10n.t('times2')}', Icons.baby_changing_station, Colors.orange),
                      _statCard(l10n.t('total_this_week'), '${freqStats['totalDiaper']}${l10n.t('times2')}', Icons.calendar_today, Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 近7天喂奶趋势
          Text(l10n.t('week_feeding_trend'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (weekFeedings.map((e) => e['count'] as int).fold(0, (a, b) => a > b ? a : b) + 2).toDouble(),
                    barGroups: weekFeedings.asMap().entries.map((e) =>
                      BarChartGroupData(x: e.key, barRods: [
                        BarChartRodData(toY: e.value['count']!.toDouble(), color: Colors.blue, width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                      ]),
                    ).toList(),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10)))),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
                        getTitlesWidget: (v, _) => Text(weekFeedings[v.toInt()]['label'] as String, style: const TextStyle(fontSize: 10)))),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 近7天换尿布趋势
          Text(l10n.t('week_diaper_trend'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (weekDiapers.map((e) => e['count'] as int).fold(0, (a, b) => a > b ? a : b) + 2).toDouble(),
                    barGroups: weekDiapers.asMap().entries.map((e) =>
                      BarChartGroupData(x: e.key, barRods: [
                        BarChartRodData(toY: e.value['count']!.toDouble(), color: Colors.orange, width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                      ]),
                    ).toList(),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10)))),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
                        getTitlesWidget: (v, _) => Text(weekDiapers[v.toInt()]['label'] as String, style: const TextStyle(fontSize: 10)))),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
