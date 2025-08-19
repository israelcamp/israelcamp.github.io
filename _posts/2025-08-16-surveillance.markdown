---
layout: post_content
name: Homemad Surveillance System
desc: How I built a homemade surveillance system using opensource software and ESP32 boards.
date: 2025-08-16 
---

To build my own security system I am using as hardware:
1. **ESP32-CAM**: R\$78.00 brazilian reais, around 14.35 USD.
1. **ESP32 WiFi**: R\$40.00, around 7.36 USD.
1. **TFT Display**: R\$50.00, around 9 USD.

The software I am using are:
1. Go server
1. Python for AI processes

The idea is to install the ESP32-CAM at some spot in my house that allows me to see outside.
The ESP32-CAM is connected to my house WiFi.
I altered the default image quality and size to stream a 640x480 image.

The Go sever will be my main form of connection to the camera feed. Because the ESP32-CAM cannot handle well multiple connections I decided to make a Go server that will stay connected to the camera feeds and keep the last frame on memory. This will allow me to fetch the image from the ESP32-CAM only once and feed it to as many connections as I need through the go server. This server will have 4 main endpoints:

1. `/stream` - opens a connection to keep feeding the client with the latest frame from the ESP32-CAM
1. `/capture` - serves the last frame in base64
1. `/streamai` - the same as `/stream` with the difference that the image fed has been processed by a YOLO model for object detection
1. `/aicapture` - the same as `/capture` but with the image processed by AI
1. `/ai` - endpoint for uploading images with the predicted bounding boxes

The AI model will run in a python script. I found easier to use python as it has more support for different models and is easier to use them.
The script will keep making requests to `/capture`, processing the imagem, drawing the bounding boxes around the detected objects and uploading the new image to another endpoint.
The uploaded image will be the one served on `/aicapture` and `/streamai`.

The model I am currently using is a **YOLO-v4-tiny** that I found the weights in github. It is super easy to use with `opencv2` and has good perfomance and speed.

**NOTE**: All the code is available [here](https://github.com/israelcamp/arduino-projects/tree/main/SurveillanceSystem).

## Setting up the ESP32-CAM

I mostly follow this [guide](https://www.diyengineers.com/2023/04/13/esp32-cam-complete-guide/) to prepare the ESP32-CAM Web Server. It has all the information needed to connect the pins correctly and upload the code via the **Arduino-IDE**. Notice that if you use a programming board you do not need the FTDI board and can simply connect the ESP32-CAM to the computer using a micro-usb cable, like I did.

The code for the server can be found in the examples for the ESP32-CAM in the Arduino-IDE, however I made a few changes. I removed any unnecessary conditional and information in the code. I also changed the default quality and framesize to **6** and **640x480**, respectively. Because I might deploy in different places, that have different WiFi, I creadted a function that would test both WiFi and keep connected to the one with the strongest signal.

Here is the main code for the ESP32-CAM Web Server:

```cpp
#include "esp_camera.h"
#define CAMERA_MODEL_AI_THINKER // Has PSRAM
#include "camera_pins.h"
#include "wifi.h"

void startCameraServer();
void setupLedFlash(int pin);

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  Serial.println();

  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.frame_size = FRAMESIZE_VGA;
  config.pixel_format = PIXFORMAT_JPEG;  // for streaming
  config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
  config.fb_location = CAMERA_FB_IN_PSRAM;
  config.jpeg_quality = 6;
  config.fb_count = 1;

  // camera init
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }

  sensor_t *s = esp_camera_sensor_get();

// Setup LED FLash if LED pin is defined in camera_pins.h
#if defined(LED_GPIO_NUM)
  setupLedFlash(LED_GPIO_NUM);
#endif

  connectToStrongestWiFi();

  startCameraServer();

  Serial.print("Camera Ready! Use 'http://");
  Serial.print(WiFi.localIP());
  Serial.println("' to connect");
}

void loop() {
  // Do nothing. Everything is done in another task by the web server
  delay(100000);
}
```

## Setting up the Go server

Because I had troubles opening multiple connections to the ESP32-CAM Web Server, probably because it can not handle much since its already video streaming, I decided to create a server using **Golang**.
This server is responsible for connecting to the video streaming and keep the current frame in buffer, any client connecting to it will receive the current frame captured from the camera, this allows a single connection to the ESP32-CAM, but it does not limit the number of clients that can receive the video streaming.

The idea for the future is to have more micro-controllers connected to this server that can receive and send requests, so that I can control multiple micro-controllers from a single application.

A **go** coroutine runs in the background as soon as the applications is initiaded, this is responsible for updating the current frame taken from the camera. The endpoints that serves the images directly are:

1. `/stream` - opens a connection to keep feeding the client with the latest frame from the ESP32-CAM
1. `/capture` - serves the last frame
1. `/b64capture` - servers the last frame in base64



