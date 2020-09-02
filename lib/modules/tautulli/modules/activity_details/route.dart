import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliActivityDetailsRouteArguments {
    final String sessionId;

    TautulliActivityDetailsRouteArguments({
        @required this.sessionId,
    });
}

class TautulliActivityDetailsRoute extends StatefulWidget {
    static const ROUTE_NAME = '/tautulli/activity/details';

    TautulliActivityDetailsRoute({
        Key key,
    }): super(key: key);

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<TautulliActivityDetailsRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
    TautulliActivityDetailsRouteArguments _arguments;

    @override
    void initState() {
        super.initState();
        SchedulerBinding.instance.scheduleFrameCallback((_) {
            setState(() => _arguments = ModalRoute.of(context).settings.arguments);
        });
    }

    Future<void> _refresh() async {
        TautulliState _state = Provider.of<TautulliState>(context, listen: false);
        _state.resetActivity();
        await _state.activity;
    }

    @override
    Widget build(BuildContext context) => _arguments == null
        ? Scaffold()
        : Scaffold(
            key: _scaffoldKey,
            appBar: _appBar,
            body: _body,
        );

    Widget get _appBar => LSAppBar(
        title: 'Activity Details',
        actions: [
            TautulliActivityDetailsMetadata(),
        ],
    );

    Widget get _body => LSRefreshIndicator(
        refreshKey: _refreshKey,
        onRefresh: _refresh,
        child: Selector<TautulliState, Future<TautulliActivity>>(
            selector: (_, state) => state.activity,
            builder: (context, future, _) => FutureBuilder(
                future: future,
                builder: (context, AsyncSnapshot<TautulliActivity> snapshot) {
                    if(snapshot.hasError) {
                        if(snapshot.connectionState != ConnectionState.waiting) {
                            Logger.error(
                                'TautulliActivityDetailsRoute',
                                '_body',
                                'Unable to pull Tautulli activity session',
                                snapshot.error,
                                null,
                                uploadToSentry: !(snapshot.error is DioError),
                            );
                        }
                        return LSErrorMessage(onTapHandler: () => _refresh());
                    }
                    if(snapshot.hasData) {
                        TautulliSession session = snapshot.data.sessions.firstWhere((element) => element.sessionId == _arguments.sessionId, orElse: () => null);
                        return session == null
                            ? _deadSession()
                            : _activeSession(session);
                    }       
                    return LSLoader();
                },
            ),
        ),
    );

    Widget _activeSession(TautulliSession session) => TautulliActivityDetailsInformation(session: session);

    Widget _deadSession() => LSGenericMessage(
        text: 'Session Ended',
        showButton: true,
        buttonText: 'Back',
        onTapHandler: () async => Navigator.of(context).pop(),
    );
}