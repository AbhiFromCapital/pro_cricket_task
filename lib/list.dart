import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<ValueNotifier<int>> _counts =
      List.generate(100, (index) => ValueNotifier(0));

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  /// Scroll handler for Controller
  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;
    if (maxScroll == _scrollController.offset) _resetCounts();
    if (minScroll == _scrollController.offset) _resetCounts();
  }

  /// Method to reset counts
  void _resetCounts() {
    for (final count in _counts) {
      count.value = 0;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    for (final count in _counts) {
      count.dispose();
    }
    _counts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(("Pro Cricket Task"))),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _counts.length,
        itemBuilder: (context, index) =>
            ListItemWidget(key: ValueKey(index), _counts[index]),
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final ValueNotifier<int> countValue;

  const ListItemWidget(this.countValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        child: ValueListenableBuilder(
          valueListenable: countValue,
          builder: (context, value, child) => Row(
            children: [
              Text("$value"),
              MaterialButton(
                onPressed: () => countValue.value++,
                child: const Text("+"),
              )
            ],
          ),
        ));
  }
}
