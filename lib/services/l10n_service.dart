import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class L10nService extends ChangeNotifier {
  static const String _localeKey = 'locale';

  static const supportedLocales = {'ru': 'Русский', 'en': 'English'};

  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  bool _initialized = false;
  bool get initialized => _initialized;

  // ─────────────────────────────────────────────
  // Translation maps
  // ─────────────────────────────────────────────

  static const Map<String, String> _ru = {
    // App & Navigation
    'app_title': 'Сева- кабачок',
    'home': 'Главная',
    'history': 'История',
    'stats': 'Статистика',
    'settings': 'Настройки',

    // Home screen
    'today': 'Сегодня',
    'quick_records': 'Быстрые записи',
    'recent_feeding': 'Последние кормления',
    'recent_diaper': 'Последние подгузники',
    'no_records_today': 'Сегодня записей нет',
    'feeding': 'Кормление',
    'milk_amount': 'Молоко',
    'diaper': 'Подгузник',
    'sleep': 'Сон',
    'ad_vitamin': 'AD',
    'd3_vitamin': 'D3',
    'sleeping': 'Спит',
    'times': 'раз',
    'minutes': 'мин',

    // Feeding screen
    'feeding_record': 'Запись кормления',
    'add_record': 'Добавить запись',
    'breast_direct': 'Грудь',
    'breast_bottle': 'Сцеженное из бутылочки',
    'formula': 'Смесь',
    'duration': 'Длительность',
    'milk_amount_ml': 'Объём молока (мл)',
    'note_optional': 'Заметка (необязательно)',
    'note_hint': 'Например: отказался / срыгнул / бодрый',
    'save_record': 'Сохранить запись',
    'start_timer': 'Запустить таймер',
    'stop_timer': 'Остановить таймер',
    'reset': 'Сброс',
    'seconds': 'сек',
    'breast_side': 'Сторона кормления',
    'left_side': 'Левая',
    'right_side': 'Правая',
    'switch_side': 'Сменить сторону',
    'completed_15min': 'Уже 15 минут',
    'use_timer': 'Таймер',
    'manual_input': 'Вручную',
    'duration_minutes': 'Длительность (мин)',

    // Diaper screen
    'diaper_record': 'Запись подгузника',
    'pee': 'Моча',
    'poop': 'Стул',
    'both': 'Оба',
    'poop_color': 'Цвет стула',
    'poop_hint': 'Например: необычная форма / прожилки крови',

    // Supplement screen
    'supplement': 'Добавки',
    'today_supplement': 'Добавки сегодня',
    'vitamin_ad': 'Витамин AD',
    'vitamin_ad_desc': 'Поддержка костей и иммунитета',
    'vitamin_d3': 'Витамин D3',
    'vitamin_d3_desc': 'Усвоение кальция',
    'save': 'Сохранить',
    'tip': 'Совет',
    'tip_content': 'AD и D3 обычно начинают давать через 15 дней после рождения. Лучше после утреннего кормления. Точную дозировку уточняйте у врача.',

    // Sleep screen
    'sleep_record': 'Запись сна',
    'baby_sleeping': 'Малыш спит 😴',
    'baby_awake': 'Малыш бодрствует ☀️',
    'has_slept': 'Спит уже',
    'hours': 'ч',
    'minutes2': 'мин',
    'start_record_sleep': 'Начать запись сна',
    'sleep_quality': 'Качество сна',
    'quality_good': 'Хорошо',
    'quality_normal': 'Нормально',
    'quality_crying': 'Плачет',
    'wake_up': 'Проснулся , завершить сон',
    'sleep_history': 'История',
    'no_history': 'Истории пока нет',
    'sleep_duration': 'Длительность сна',
    'quality': 'Качество',

    // Growth screen
    'growth_record': 'Рост и вес',
    'latest_record': 'Последняя запись',
    'weight_kg': 'Вес (кг)',
    'height_cm': 'Рост (см)',
    'head_cm': 'Окружность головы (см)',
    'weight': 'Вес',
    'height': 'Рост',
    'head': 'Голова',
    'history_records': 'История записей',

    // Milestone screen
    'milestone': 'Этапы развития и заметки',
    'milestone_tab': '🌟 Этапы',
    'hospital_tab': '🏥 Врач',
    'vaccine_tab': '💉 Вакцины',
    'title': 'Заголовок',
    'date': 'Дата',
    // Preset milestones
    'first_smile': 'Первая улыбка',
    'roll_over': 'Перевернулся',
    'sit_up': 'Сидит самостоятельно',
    'crawl': 'Ползает',
    'stand': 'Стоит',
    'first_steps': 'Первые шаги',
    'first_words': 'Первые слова',
    'teething': 'Прорезывание зубов',
    'recognize_people': 'Узнаёт близких',
    'stranger_anxiety': 'Боится незнакомых',
    'checkup': 'Осмотр',
    'visit': 'Приём у врача',
    'review': 'Повторный осмотр',
    'medicine': 'Лекарства',
    'vaccination': 'Вакцинация',

    // History screen
    'history_title': 'История',
    'no_records': 'Записей нет',
    'pee_poop': 'Моча/стул',

    // Stats screen
    'stats_title': 'Статистика',
    'today_overview': 'Обзор за сегодня',
    'feeding_times': 'Кормления',
    'total_milk': 'Всего молока',
    'diaper_count': 'Подгузники',
    'diaper_detail': 'Моча/стул',
    'sleep_duration2': 'Сон',
    'breast_duration': 'Грудное вскармливание',
    'week_feeding_trend': 'Кормления за 7 дней',
    'week_diaper_trend': 'Подгузники за 7 дней',
    'times2': 'раз',

    // Settings screen
    'baby_info': 'Информация о малыше',
    'baby_name': 'Имя малыша',
    'birth_date': 'Дата рождения',
    'please_fill': 'Заполни имя малыша и дату рождения',
    'saved': 'Сохранено!',
    'language': 'Язык',
    'chinese': 'Русский',
    'english': 'English',
    'version': 'Версия',
    'about': 'О приложении',
    'about_subtitle': 'Сева- кабачок , заботливо рядом каждый день',
    'data_export': 'Экспорт данных (в разработке)',
    'data_export_desc': 'Экспорт в Excel для врача',
    'dev_in_progress': 'В разработке',
    'about_app': 'Сева- кабачок',
    'about_version': '1.0.0',
    'about_description': 'Записывай каждый шаг роста малыша',
    'about_features': 'Функции: кормление | подгузники | сон | добавки | рост | этапы развития',

    // Weekdays
    'mon': 'Пн',
    'tue': 'Вт',
    'wed': 'Ср',
    'thu': 'Чт',
    'fri': 'Пт',
    'sat': 'Сб',
    'sun': 'Вс',

    // Age display
    'months': 'мес',
    'years': 'лет',

    // Stats new fields
    'weekly_frequency': 'Частота за неделю',
    'avg_per_day': 'Среднее в день',
    'total_this_week': 'Всего за неделю',
    'feeding_interval': 'Интервал кормления',
    'diaper_interval': 'Интервал подгузников',
    'avg_interval': 'Средний',
    'min_interval': 'Минимальный',
    'max_interval': 'Максимальный',
    'recent_intervals': 'Последние интервалы',
    'merged_events': 'Объединённые события',
    'merge_hint': 'События в пределах 10 минут',
  };

  static const Map<String, String> _en = {
    // App & Navigation
    'app_title': 'Сева- кабачок',
    'home': 'Home',
    'history': 'History',
    'stats': 'Stats',
    'settings': 'Settings',

    // Home screen
    'today': 'Today',
    'quick_records': 'Quick Add',
    'recent_feeding': 'Recent Feedings',
    'recent_diaper': 'Recent Diapers',
    'no_records_today': 'No records today',
    'feeding': 'Feeding',
    'milk_amount': 'Milk',
    'diaper': 'Diaper',
    'sleep': 'Sleep',
    'ad_vitamin': 'AD',
    'd3_vitamin': 'D3',
    'sleeping': 'Sleeping',
    'times': 'x',
    'minutes': 'min',

    // Feeding screen
    'feeding_record': 'Feeding Record',
    'add_record': 'Add Record',
    'breast_direct': 'Breast',
    'breast_bottle': 'Bottle (EBM)',
    'formula': 'Formula',
    'duration': 'Duration',
    'milk_amount_ml': 'Amount (ml)',
    'note_optional': 'Note (optional)',
    'note_hint': 'e.g. refused/sneezed/active',
    'save_record': 'Save Record',
    'start_timer': 'Start Timer',
    'stop_timer': 'Stop Timer',
    'reset': 'Reset',
    'seconds': 's',
    'breast_side': 'Side',
    'left_side': 'Left',
    'right_side': 'Right',
    'switch_side': 'Switch',
    'completed_15min': '15 min completed',
    'use_timer': 'Timer',
    'manual_input': 'Manual',
    'duration_minutes': 'Duration (min)',

    // Diaper screen
    'diaper_record': 'Diaper Record',
    'pee': 'Wet',
    'poop': 'Dirty',
    'both': 'Both',
    'poop_color': 'Poop Color',
    'poop_hint': 'e.g. abnormal shape/blood',

    // Supplement screen
    'supplement': 'Supplements',
    'today_supplement': "Today's Supplements",
    'vitamin_ad': 'Vitamin AD',
    'vitamin_ad_desc': 'Bone & immune support',
    'vitamin_d3': 'Vitamin D3',
    'vitamin_d3_desc': 'Calcium absorption',
    'save': 'Save',
    'tip': '💡 Tip',
    'tip_content': 'AD & D3 usually start 15 days after birth, best taken after morning feed. Follow your doctor\'s advice.',

    // Sleep screen
    'sleep_record': 'Sleep Record',
    'baby_sleeping': 'Baby is sleeping 😴',
    'baby_awake': 'Baby is awake ☀️',
    'has_slept': 'Asleep for',
    'hours': 'h',
    'minutes2': 'm',
    'start_record_sleep': 'Start Sleep Record',
    'sleep_quality': 'Sleep Quality',
    'quality_good': 'Good',
    'quality_normal': 'Fair',
    'quality_crying': 'Fussy',
    'wake_up': 'Wake Up — End Sleep',
    'sleep_history': 'History',
    'no_history': 'No history yet',
    'sleep_duration': 'Duration',
    'quality': 'Quality',

    // Growth screen
    'growth_record': 'Growth Record',
    'latest_record': 'Latest',
    'weight_kg': 'Weight (kg)',
    'height_cm': 'Height (cm)',
    'head_cm': 'Head (cm)',
    'weight': 'Weight',
    'height': 'Height',
    'head': 'Head',
    'history_records': 'History',

    // Milestone screen
    'milestone': 'Milestones',
    'milestone_tab': '🌟 Milestone',
    'hospital_tab': '🏥 Medical',
    'vaccine_tab': '💉 Vaccine',
    'title': 'Title',
    'date': 'Date',
    // Preset milestones
    'first_smile': 'First Smile',
    'roll_over': 'Roll Over',
    'sit_up': 'Sit Up',
    'crawl': 'Crawl',
    'stand': 'Stand',
    'first_steps': 'First Steps',
    'first_words': 'First Words',
    'teething': 'Teething',
    'recognize_people': 'Recognizes Faces',
    'stranger_anxiety': 'Stranger Anxiety',
    'checkup': 'Checkup',
    'visit': 'Doctor Visit',
    'review': 'Follow-up',
    'medicine': 'Medication',
    'vaccination': 'Vaccination',

    // History screen
    'history_title': 'History',
    'no_records': 'No records',
    'pee_poop': 'Wet/Dirty',

    // Stats screen
    'stats_title': 'Statistics',
    'today_overview': "Today's Overview",
    'feeding_times': 'Feedings',
    'total_milk': 'Total Milk',
    'diaper_count': 'Diapers',
    'diaper_detail': 'Wet/Dirty',
    'sleep_duration2': 'Sleep',
    'breast_duration': 'Breastfeeding',
    'week_feeding_trend': 'Feeding (Last 7 Days)',
    'week_diaper_trend': 'Diapers (Last 7 Days)',
    'times2': 'x',

    // Settings screen
    'baby_info': 'Baby Info',
    'baby_name': 'Baby Name',
    'birth_date': 'Birth Date',
    'please_fill': 'Please fill in baby name and birth date',
    'saved': 'Saved!',
    'language': 'Language',
    'chinese': 'Русский',
    'english': 'English',
    'version': 'Version',
    'about': 'About',
    'about_subtitle': 'Сева- кабачок , записывай каждый шаг малыша',
    'data_export': 'Export Data (Coming Soon)',
    'data_export_desc': 'Export to Excel for doctor visits',
    'dev_in_progress': 'Coming Soon',
    'about_app': 'Сева- кабачок',
    'about_version': '2.0.0',
    'about_description': 'Track every step of your baby\'s growth',
    'about_features': 'Features: Feeding | Diapers | Sleep | Supplements | Growth | Milestones',

    // Weekdays
    'mon': 'Mon',
    'tue': 'Tue',
    'wed': 'Wed',
    'thu': 'Thu',
    'fri': 'Fri',
    'sat': 'Sat',
    'sun': 'Sun',

    // Age display
    'months': 'mo',
    'years': 'yr',

    // Stats new fields
    'weekly_frequency': 'Weekly Frequency',
    'avg_per_day': 'Daily Avg',
    'total_this_week': 'This Week',
    'feeding_interval': 'Feeding Interval',
    'diaper_interval': 'Diaper Interval',
    'avg_interval': 'Avg',
    'min_interval': 'Min',
    'max_interval': 'Max',
    'recent_intervals': 'Recent Intervals',
    'merged_events': 'Merged Events',
    'merge_hint': 'Events within 10 min',
  };

  // ─────────────────────────────────────────────
  // Init & locale management
  // ─────────────────────────────────────────────

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_localeKey);
    if (saved != null && supportedLocales.containsKey(saved)) {
      _locale = Locale(saved);
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLocale(String lang) async {
    if (!supportedLocales.containsKey(lang)) return;
    _locale = Locale(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, lang);
    notifyListeners();
  }

  String t(String key) {
    final map = _locale.languageCode == 'en' ? _en : _ru;
    return map[key] ?? key;
  }
}
