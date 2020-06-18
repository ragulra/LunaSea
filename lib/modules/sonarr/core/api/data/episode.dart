import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:intl/intl.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrEpisodeData {
    String episodeTitle;
    String airDate;
    String quality;
    String overview;
    int seasonNumber;
    int episodeNumber;
    int episodeID;
    int episodeFileID;
    int size;
    bool isMonitored;
    bool hasFile;
    bool cutoffNotMet;
    SonarrQueueData queue;
    bool isSelected = false;

    SonarrEpisodeData({
        @required this.episodeTitle,
        @required this.seasonNumber,
        @required this.episodeNumber,
        @required this.airDate,
        @required this.episodeID,
        @required this.episodeFileID,
        @required this.isMonitored,
        @required this.hasFile,
        @required this.quality,
        @required this.cutoffNotMet,
        @required this.size,
        @required this.queue,
        @required this.overview,
    });

    String get sizeString {
        return size?.lsBytes_BytesToString();
    }

    DateTime get airDateObject {
        if(airDate != null) {
            return DateTime.tryParse(airDate)?.toLocal();
        }
        return null;
    }

    String get airDateString {
        if(airDateObject != null) {
            return DateFormat('MMMM dd, y').format(airDateObject);
        }
        return 'Unknown Air Date';
    }

    bool get hasAired {
        if(airDateObject == null) {
            return false;
        }
        return airDateObject.isBefore(DateTime.now());
    }

    dynamic subtitle({ bool asHighlight = false }) {
        if(queue != null) {
            return asHighlight
                ? LSTextHighlighted(
                    text: '${queue?.status ?? 'Unknown'} (${(100-((queue?.sizeLeft ?? 0)/(queue?.size ?? 1))*100).abs().toInt()}%)',
                    bgColor: Colors.blue,   
                )
                : TextSpan(
                    text: '${queue?.status ?? 'Unknown'} (${(100-((queue?.sizeLeft ?? 0)/(queue?.size ?? 1))*100).abs().toInt()}%)',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                    ),
            );
        }
        if(hasFile) {
            if(cutoffNotMet) {
                return asHighlight
                    ? LSTextHighlighted(
                        text: '$quality - $sizeString',
                        bgColor: LSColors.orange,
                    )
                    : TextSpan(
                        text: '$quality - $sizeString',
                        style: TextStyle(
                            color: isMonitored ? Colors.orange : Colors.orange.withOpacity(0.30),
                            fontWeight: FontWeight.bold,
                        ),
                    );
            }
            return asHighlight
                ? LSTextHighlighted(
                    text: '$quality - $sizeString',
                    bgColor: LSColors.accent,
                )
                : TextSpan(
                    text: '$quality - $sizeString',
                    style: TextStyle(
                        color: isMonitored ? Color(Constants.ACCENT_COLOR) : Color(Constants.ACCENT_COLOR).withOpacity(0.30),
                        fontWeight: FontWeight.bold,
                    ),
                );
        }
        if(hasAired) {
            return asHighlight
                ? LSTextHighlighted(
                    text: 'Missing',
                    bgColor: LSColors.red,
                )
                : TextSpan(
                    text: 'Missing',
                    style: TextStyle(
                        color: isMonitored ? Colors.red : Colors.red.withOpacity(0.30),
                        fontWeight: FontWeight.bold,
                    ),
                );
        }
        return asHighlight
            ? LSTextHighlighted(
                text: 'Unaired',
                bgColor: LSColors.blue,
            )
            : TextSpan(
                text: 'Unaired',
                style: TextStyle(
                    color: isMonitored ? Colors.blue : Colors.blue.withOpacity(0.30),
                    fontWeight: FontWeight.bold,
                ),
            );
    }
}
