plugins {
    id("com.android.application")
    id("kotlin-android")

    // ✅ Firebase support
    id("com.google.gms.google-services")

    // ✅ Flutter plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.crud"
    compileSdk = flutter.compileSdkVersion

    // ✅ Use correct NDK version for Firebase
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.crud"

        // ✅ Updated as firebase-auth requires at least 23
        minSdk = 23

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM - controls versions of all Firebase libs
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // ✅ Uncomment the Firebase features you need:
    implementation("com.google.firebase:firebase-auth-ktx")
    // implementation("com.google.firebase:firebase-firestore-ktx")
    // implementation("com.google.firebase:firebase-database-ktx")
    // implementation("com.google.firebase:firebase-analytics-ktx")
}
