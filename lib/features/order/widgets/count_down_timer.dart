import 'dart:async';

import 'package:flutter/material.dart';

import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime estimatedDeliveryTime;
  final TextStyle? textStyle;

  const CountdownTimerWidget(
      {super.key, required this.estimatedDeliveryTime, this.textStyle});

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _calculateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _calculateTime());
  }

  void _calculateTime() {
    final now = DateTime.now();
    _remainingTime = widget.estimatedDeliveryTime.isAfter(now)
        ? widget.estimatedDeliveryTime.difference(now)
        : Duration.zero;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes =
        _remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        _remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Text(
      '${_remainingTime.inHours > 0 ? '${_remainingTime.inHours}:' : ''}$minutes:$seconds',
      style: widget.textStyle ??
          robotoBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            color: Theme.of(context).primaryColor,
          ),
    );
  }
}
