package com.example.androiddemo

import android.app.Application
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.interfaces.INativeRouter
import com.ziwenl.androiddemo.router.PageRouter
import io.flutter.embedding.android.FlutterView

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        //引擎生命周期监听
        val boostLifecycleListener = object : FlutterBoost.BoostLifecycleListener {
            override fun onEngineCreated() {
                //引擎创建成功
            }

            override fun onPluginsRegistered() {
                //插件注册
            }

            override fun beforeCreateEngine() {
                //创建引擎前
            }

            override fun onEngineDestroy() {
                //引擎被销毁
            }
        }
        //路由跳转监听
        val router = INativeRouter { context, url, urlParams, requestCode, exts ->
            //当 Flutter 中使用 FlutterBoost 启动新页面 (Flutter/Native) 时，触发该回调
            PageRouter.openPageByUrl(context, url, urlParams, requestCode)
        }
        //
        // AndroidManifest.xml 中必须要添加 flutterEmbedding 版本设置
        //
        //   <meta-data android:name="flutterEmbedding"
        //               android:value="2">
        //    </meta-data>
        //
        val platform = FlutterBoost.ConfigBuilder(this, router)
            .isDebug(true)
            .whenEngineStart(FlutterBoost.ConfigBuilder.ANY_ACTIVITY_CREATED)
            .renderMode(FlutterView.RenderMode.texture)
            .lifecycleListener(boostLifecycleListener)
            .build()
        FlutterBoost.instance().init(platform)

    }
}