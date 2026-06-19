function insertSE(filePath, trackIndex, volumeDb) {
  try {
    var project = app.project;
    if (!project) return "ERROR: プロジェクトなし";
    var sequence = project.activeSequence;
    if (!sequence) return "ERROR: シーケンスなし";
    var projectItem = findOrImportItem(project, filePath);
    if (!projectItem) return "ERROR: インポート失敗";
    var insertTime = sequence.getPlayerPosition();
    var audioTrackIndex = trackIndex - 1;
    if (audioTrackIndex < 0) audioTrackIndex = 0;
    var audioTracks = sequence.audioTracks;
    if (audioTrackIndex >= audioTracks.numTracks) audioTrackIndex = audioTracks.numTracks - 1;
    var audioTrack = audioTracks[audioTrackIndex];
    audioTrack.insertClip(projectItem, insertTime);
    var clips = audioTrack.clips;
    var insertTimeSec = insertTime.seconds;
    var insertedClip = null;
    for (var i = 0; i < clips.numItems; i++) {
      if (Math.abs(clips[i].start.seconds - insertTimeSec) < 0.5) {
        insertedClip = clips[i];
        break;
      }
    }
    if (!insertedClip) return "OK配置済 | クリップ取得失敗";

    // ボリューム > レベル プロパティを探してsetValue
    var comps = insertedClip.components;
    for (var j = 0; j < comps.numItems; j++) {
      var comp = comps[j];
      if (comp.displayName === "ボリューム" || comp.displayName === "Volume") {
        var props = comp.properties;
        for (var k = 0; k < props.numItems; k++) {
          var prop = props[k];
          if (prop.displayName === "レベル" || prop.displayName === "Level") {
            // dBをそのまま渡す
            var result = prop.setValue(volumeDb, true);
            var currentVal = prop.getValue();
            return "OK配置済 | setValue結果:" + result + " | 現在値:" + currentVal;
          }
        }
      }
    }
    return "OK配置済 | ボリュームコンポーネント見つからず";
  } catch(e) {
    return "ERROR: " + e.message;
  }
}

function findOrImportItem(project, filePath) {
  var rootItem = project.rootItem;
  for (var i = 0; i < rootItem.children.numItems; i++) {
    var item = rootItem.children[i];
    if (item.getMediaPath && item.getMediaPath() === filePath) return item;
  }
  project.importFiles([filePath], true, project.rootItem, false);
  for (var j = 0; j < rootItem.children.numItems; j++) {
    var newItem = rootItem.children[j];
    if (newItem.getMediaPath && newItem.getMediaPath() === filePath) return newItem;
  }
  return null;
}
