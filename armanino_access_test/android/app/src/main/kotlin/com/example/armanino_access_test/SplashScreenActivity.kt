package com.example.armanino_access_test
//package com.armanino.armaninoaccesstest

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class SplashScreenActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setTheme(R.style.ArmaninoAccessTheme) // Set the custom theme
    }
}
