/**
 * @flow
 */

import { NativeModules } from 'react-native';

const { RNTranscodeImage } = NativeModules;

/*flow-include
export type TranscodeOptions = {
  outputFormat?: 'jpg' | 'png',
  quality?: number
}
*/

/**
 * Convert an image to a different file type.
 *
 * If output format will be guessed from the destination file name
 * if it is not provided in the options.
 */
export async function transcodeImage(
  source /*: string */,
  destination /*: string */,
  options /*: TranscodeOptions */ = {}
) {
  let res /*: {size: number} */ = await RNTranscodeImage.transcodeImage(source, destination, options);
  return res;
}
