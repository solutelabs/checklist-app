import 'package:checklist/models/list_mode.dart';
import 'package:checklist/pages/add_item_page.dart';
import 'package:checklist/pages/home/dashboard_view.dart';
import 'package:checklist/pages/home/items_list_view.dart';
import 'package:checklist/pages/item_details/item_details_view.dart';
import 'package:flutter/material.dart';

class RegularHomePage extends StatefulWidget {
  @override
  _RegularHomePageState createState() => _RegularHomePageState();
}

class _RegularHomePageState extends State<RegularHomePage> {
  static const double dashboardWidth = 160;
  static const double listMinWidth = 400;
  static const double detailsPageMaxWidth = 300;

  ListMode _currentMode;
  String selectedItemId;

  @override
  void initState() {
    super.initState();
    _currentMode = ListMode.all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: dashboardWidth,
                    child: DashboardView(
                      onModeSelected: (mode) async {
                        setState(() {
                          _currentMode = mode;
                          debugPrint(_currentMode.toString());
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ItemsListView(
                      key: Key(_currentMode.toString()),
                      listMode: _currentMode,
                      onItemSelected: (id) =>
                          setState(() => selectedItemId = id),
                    ),
                  ),
                  if (selectedItemId != null &&
                      !shouldShowDetailsViewAsAnOverlay(constraints.maxWidth))
                    Container(
                      width: detailsPageMaxWidth,
                      child: ItemDetailsView(
                        id: selectedItemId,
                      ),
                    ),
                ],
              ),
              if (selectedItemId != null &&
                  shouldShowDetailsViewAsAnOverlay(constraints.maxWidth))
                Container(
                  color: Colors.black.withAlpha(90),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedItemId = null),
                          ),
                        ),
                      ),
                      Container(
                        width: detailsPageMaxWidth,
                        child: ItemDetailsView(
                          id: selectedItemId,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: kElevationToShadow[8],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedItemId != null
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: AddItemPage(),
                    ),
                  );
                },
              ),
            ),
    );
  }

  bool shouldShowDetailsViewAsAnOverlay(double widht) {
    return widht < dashboardWidth + listMinWidth + detailsPageMaxWidth;
  }
}
