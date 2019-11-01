import 'package:checklist/providers/viewmodel_provider.dart';
import 'package:checklist/view_models/item_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailsView extends StatelessWidget {
  final String id;
  final VoidCallback onClose;

  bool get isFullScreen => onClose == null;

  const ItemDetailsView({
    Key key,
    @required this.id,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isFullScreen ? null : Colors.black12,
      child: Provider<ItemDetailsViewModel>(
        builder: (_) => provideItemDetailsViewModel(id),
        dispose: (_, viewModel) => viewModel.dispose(),
        child: Builder(
          builder: (context) {
            final viewModel = Provider.of<ItemDetailsViewModel>(context);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (onClose != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                    StreamBuilder<String>(
                      stream: viewModel.title,
                      initialData: '',
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          style: Theme.of(context).textTheme.title,
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    StreamBuilder<String>(
                      stream: viewModel.date,
                      initialData: '',
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '',
                          style: Theme.of(context).textTheme.subtitle,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
