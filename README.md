# react-native-transcode-image

## Getting started

`$ npm install react-native-transcode-image --save`

### Mostly automatic installation

`$ react-native link react-native-transcode-image`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-transcode-image` and add `RNTranscodeImage.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNTranscodeImage.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. In XCode, in the project navigator, select your project. Add `$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)` to your project's `Build Settings` ➜ `Library Search Paths`
5. In XCode, in the project navigator, select your project. Enable `Build Settings` ➜ `Always Embed Swift Standard Libraries` in your project
6. Run your project (`Cmd+R`)

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import io.github.alpha0010.RNTranscodeImagePackage;` to the imports at the top of the file
  - Add `new RNTranscodeImagePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-transcode-image'
  	project(':react-native-transcode-image').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-transcode-image/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      implementation project(':react-native-transcode-image')
  	```


## Usage
```javascript
import { transcodeImage } from 'react-native-transcode-image';

transcodeImage(pngName, jpgName, {quality: 95})
  .then(res => console.log(res.size))
  .catch(err => console.log(err));
```
