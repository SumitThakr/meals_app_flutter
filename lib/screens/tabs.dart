import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app_flutter/providers/favorites_provider.dart';
import 'package:meals_app_flutter/screens/categories.dart';
import 'package:meals_app_flutter/screens/meals.dart';

import '../providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegatarian: false,
  Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                var availableMeals = ref.watch(filteredMealsProvider);
                return CupertinoPageScaffold(
                  child: CategoriesScreen(
                    availableMeals: availableMeals,
                    title: 'Categories',
                  ),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                var favoriteMeals = ref.watch(favoriteMealsProvider);
                return CupertinoPageScaffold(
                  child: MealsScreen(
                    meals: favoriteMeals,
                    title: 'Your Favorites',
                  ),
                );
              },
            );
        }
        return const Text("Hello Last");
      },
    );
  }
}
