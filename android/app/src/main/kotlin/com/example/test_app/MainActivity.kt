package com.example.test_app

import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.app.ActivityManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.annotation.NonNull

class MainActivity : FlutterActivity() {
    private val CHANNEL = "device_info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(DeviceInfoMethodHandler(this))
    }

    class DeviceInfoMethodHandler(private val context: Context) : MethodCallHandler {
        override fun onMethodCall(call: MethodCall, result: Result) {
            when (call.method) {
                "getDeviceInfo" -> {
                    val deviceInfo = getDeviceInfo()
                    result.success(deviceInfo)
                }
                else -> result.notImplemented()
            }
        }

        private fun getDeviceInfo(): Map<String, String> {
            val ram = getRamSizeInGB()
            val rom = getRomSizeInGB()
            val batteryCapacity = getBatteryCapacity()
            return mapOf("ram" to ram, "rom" to rom, "battery" to batteryCapacity)
        }

        private fun getRamSizeInGB(): String {
            val actManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            actManager.getMemoryInfo(memInfo)
            val ramSizeGB = memInfo.totalMem.toDouble() / (1024 * 1024 * 1024) // Convert to gigabytes
            return String.format("%.2f GB", ramSizeGB) // Format to display with two decimal places
        }

        private fun getRomSizeInGB(): String {
            val stat = StatFs(Environment.getDataDirectory().absolutePath)
            val blockSize = stat.blockSizeLong
            val totalBlocks = stat.blockCountLong
            val totalSize = totalBlocks * blockSize
            val romSizeGB = totalSize.toDouble() / (1024 * 1024 * 1024) // Convert to gigabytes
            return String.format("%.2f GB", romSizeGB) // Format to display with two decimal places
        }

        private fun getBatteryCapacity(): String {
            val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            val batteryCapacity = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val batteryInfo = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                "$batteryInfo %"
            } else {
                "N/A" // Capacity information is not available on versions before Lollipop
            }
            return batteryCapacity
        }
    }
}



