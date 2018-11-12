package io.github.alpha0010

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.facebook.react.bridge.*
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File

internal class RNTranscodeImageModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        const val E_DECODE = "E_DECODE"
        const val E_ENCODE = "E_ENCODE"
    }

    override fun getName(): String {
        return "RNTranscodeImage"
    }

    /**
     * Convert an image to a different file type.
     *
     * If output format will be guessed from the destination file name
     * if it is not provided in the options.
     */
    @ReactMethod
    fun transcodeImage(source: String, destination: String, options: ReadableMap, promise: Promise) {
        val handler = CoroutineExceptionHandler { _, exception ->
            promise.reject(exception)
        }

        GlobalScope.launch(handler) {
            val destFile = File(destination)
            val formatStr = getOptionString(options, "outputFormat", destFile.extension)
            val outputFormat = when (formatStr.toLowerCase()) {
                "jpg" -> Bitmap.CompressFormat.JPEG
                "jpeg" -> Bitmap.CompressFormat.JPEG
                "png" -> Bitmap.CompressFormat.PNG
                "webp" -> Bitmap.CompressFormat.WEBP
                else -> {
                    promise.reject(E_ENCODE, "Cannot determine output format for '$destination'")
                    return@launch
                }
            }

            val bitmap = BitmapFactory.decodeFile(source)
            if (bitmap == null) {
                promise.reject(E_DECODE, "Failed to decode '$source'")
                return@launch
            }

            val quality = getOptionInt(options, "quality", 90)
            val outStream = destFile.outputStream()
            val success = bitmap.compress(outputFormat, quality, outStream)
            bitmap.recycle()
            outStream.close()

            if (!success) {
                promise.reject(
                        E_ENCODE,
                        "Failed to compress '$destination' (format: $outputFormat)"
                )
                return@launch
            }

            val fileSize = destFile.length()
            val map = Arguments.createMap()
            map.putInt("size", fileSize.toInt())
            promise.resolve(map)
        }
    }

    /**
     * Read an integer from the passed RN object.
     */
    private fun getOptionInt(options: ReadableMap, key: String, default: Int): Int {
        if (options.hasKey(key) && options.getType(key) == ReadableType.Number) {
            return options.getInt(key)
        }
        return default
    }

    /**
     * Read a string from the passed RN object.
     */
    private fun getOptionString(options: ReadableMap, key: String, default: String): String {
        if (options.hasKey(key) && options.getType(key) == ReadableType.String) {
            return options.getString(key)
        }
        return default
    }
}
