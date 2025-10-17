plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    // Adjust namespace/applicationId as needed for your project
    namespace = "com.example.avisa_la"
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.avisa_la"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        // Habilita core library desugaring exigido por alguns AARs (ex.: flutter_local_notifications)
        isCoreLibraryDesugaringEnabled = true
    }

    // Kotlin JVM target
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.21")
    // Adiciona a biblioteca de desugaring necessária
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
}