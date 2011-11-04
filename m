Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1KDGuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:50:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16577 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1KDGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:50:00 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-13-4eb38b169e82
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: [RFC PATCH 2/2] HWMON: adapt to the HWMON interface changes
Date: Fri, 04 Nov 2011 15:50:33 +0900
Message-id: <1320389433-1671-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 06:49:43.0680 (UTC)
 FILETIME=[EF09E000:01CC9ABD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwmon_device_register() has one more parameter now.
ntc_thermistor.c uses the additional parameter fully.
If the additional parameter is NULL, the behavior of HWMON is not
changed.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/char/i8k.c                   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c   |    2 +-
 drivers/hwmon/abituguru.c            |    2 +-
 drivers/hwmon/abituguru3.c           |    2 +-
 drivers/hwmon/acpi_power_meter.c     |    2 +-
 drivers/hwmon/ad7414.c               |    2 +-
 drivers/hwmon/ad7418.c               |    2 +-
 drivers/hwmon/adcxx.c                |    2 +-
 drivers/hwmon/adm1021.c              |    2 +-
 drivers/hwmon/adm1025.c              |    2 +-
 drivers/hwmon/adm1026.c              |    2 +-
 drivers/hwmon/adm1029.c              |    2 +-
 drivers/hwmon/adm1031.c              |    2 +-
 drivers/hwmon/adm9240.c              |    2 +-
 drivers/hwmon/ads1015.c              |    2 +-
 drivers/hwmon/ads7828.c              |    2 +-
 drivers/hwmon/ads7871.c              |    2 +-
 drivers/hwmon/adt7411.c              |    2 +-
 drivers/hwmon/adt7462.c              |    2 +-
 drivers/hwmon/adt7470.c              |    2 +-
 drivers/hwmon/adt7475.c              |    2 +-
 drivers/hwmon/amc6821.c              |    2 +-
 drivers/hwmon/applesmc.c             |    2 +-
 drivers/hwmon/asb100.c               |    2 +-
 drivers/hwmon/asc7621.c              |    2 +-
 drivers/hwmon/asus_atk0110.c         |    2 +-
 drivers/hwmon/atxp1.c                |    2 +-
 drivers/hwmon/coretemp.c             |    2 +-
 drivers/hwmon/dme1737.c              |    4 ++--
 drivers/hwmon/ds1621.c               |    2 +-
 drivers/hwmon/ds620.c                |    2 +-
 drivers/hwmon/emc1403.c              |    2 +-
 drivers/hwmon/emc2103.c              |    2 +-
 drivers/hwmon/emc6w201.c             |    2 +-
 drivers/hwmon/f71805f.c              |    2 +-
 drivers/hwmon/f71882fg.c             |    2 +-
 drivers/hwmon/f75375s.c              |    2 +-
 drivers/hwmon/fam15h_power.c         |    2 +-
 drivers/hwmon/fschmd.c               |    2 +-
 drivers/hwmon/g760a.c                |    2 +-
 drivers/hwmon/gl518sm.c              |    2 +-
 drivers/hwmon/gl520sm.c              |    2 +-
 drivers/hwmon/gpio-fan.c             |    2 +-
 drivers/hwmon/i5k_amb.c              |    2 +-
 drivers/hwmon/ibmaem.c               |    4 ++--
 drivers/hwmon/ibmpex.c               |    2 +-
 drivers/hwmon/it87.c                 |    2 +-
 drivers/hwmon/jc42.c                 |    2 +-
 drivers/hwmon/jz4740-hwmon.c         |    2 +-
 drivers/hwmon/k10temp.c              |    2 +-
 drivers/hwmon/k8temp.c               |    2 +-
 drivers/hwmon/lineage-pem.c          |    2 +-
 drivers/hwmon/lm63.c                 |    2 +-
 drivers/hwmon/lm70.c                 |    2 +-
 drivers/hwmon/lm73.c                 |    2 +-
 drivers/hwmon/lm75.c                 |    2 +-
 drivers/hwmon/lm77.c                 |    2 +-
 drivers/hwmon/lm78.c                 |    4 ++--
 drivers/hwmon/lm80.c                 |    2 +-
 drivers/hwmon/lm83.c                 |    2 +-
 drivers/hwmon/lm85.c                 |    2 +-
 drivers/hwmon/lm87.c                 |    2 +-
 drivers/hwmon/lm90.c                 |    2 +-
 drivers/hwmon/lm92.c                 |    2 +-
 drivers/hwmon/lm93.c                 |    2 +-
 drivers/hwmon/lm95241.c              |    2 +-
 drivers/hwmon/lm95245.c              |    2 +-
 drivers/hwmon/ltc4151.c              |    2 +-
 drivers/hwmon/ltc4215.c              |    2 +-
 drivers/hwmon/ltc4245.c              |    2 +-
 drivers/hwmon/ltc4261.c              |    2 +-
 drivers/hwmon/max1111.c              |    2 +-
 drivers/hwmon/max16065.c             |    2 +-
 drivers/hwmon/max1619.c              |    2 +-
 drivers/hwmon/max1668.c              |    2 +-
 drivers/hwmon/max6639.c              |    2 +-
 drivers/hwmon/max6642.c              |    2 +-
 drivers/hwmon/max6650.c              |    2 +-
 drivers/hwmon/mc13783-adc.c          |    2 +-
 drivers/hwmon/ntc_thermistor.c       |   15 +++------------
 drivers/hwmon/pc87360.c              |    2 +-
 drivers/hwmon/pc87427.c              |    2 +-
 drivers/hwmon/pcf8591.c              |    2 +-
 drivers/hwmon/pmbus/pmbus_core.c     |    2 +-
 drivers/hwmon/s3c-hwmon.c            |    2 +-
 drivers/hwmon/sch5627.c              |    2 +-
 drivers/hwmon/sch5636.c              |    2 +-
 drivers/hwmon/sht15.c                |    2 +-
 drivers/hwmon/sht21.c                |    2 +-
 drivers/hwmon/sis5595.c              |    2 +-
 drivers/hwmon/smm665.c               |    2 +-
 drivers/hwmon/smsc47b397.c           |    2 +-
 drivers/hwmon/smsc47m1.c             |    2 +-
 drivers/hwmon/smsc47m192.c           |    2 +-
 drivers/hwmon/thmc50.c               |    2 +-
 drivers/hwmon/tmp102.c               |    2 +-
 drivers/hwmon/tmp401.c               |    2 +-
 drivers/hwmon/tmp421.c               |    2 +-
 drivers/hwmon/twl4030-madc-hwmon.c   |    2 +-
 drivers/hwmon/ultra45_env.c          |    2 +-
 drivers/hwmon/via-cputemp.c          |    2 +-
 drivers/hwmon/via686a.c              |    2 +-
 drivers/hwmon/vt1211.c               |    2 +-
 drivers/hwmon/vt8231.c               |    2 +-
 drivers/hwmon/w83627ehf.c            |    2 +-
 drivers/hwmon/w83627hf.c             |    2 +-
 drivers/hwmon/w83781d.c              |    4 ++--
 drivers/hwmon/w83791d.c              |    2 +-
 drivers/hwmon/w83792d.c              |    2 +-
 drivers/hwmon/w83793.c               |    2 +-
 drivers/hwmon/w83795.c               |    2 +-
 drivers/hwmon/w83l785ts.c            |    2 +-
 drivers/hwmon/w83l786ng.c            |    2 +-
 drivers/hwmon/wm831x-hwmon.c         |    2 +-
 drivers/hwmon/wm8350-hwmon.c         |    2 +-
 drivers/input/touchscreen/ads7846.c  |    2 +-
 drivers/platform/x86/asus-wmi.c      |    2 +-
 drivers/platform/x86/compal-laptop.c |    2 +-
 drivers/platform/x86/eeepc-laptop.c  |    2 +-
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 drivers/thermal/thermal_sys.c        |    2 +-
 122 files changed, 128 insertions(+), 137 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 6e40072..457425d 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -531,7 +531,7 @@ static int __init i8k_init_hwmon(void)
 {
 	int err;
 
-	i8k_hwmon_dev = hwmon_device_register(NULL);
+	i8k_hwmon_dev = hwmon_device_register(NULL, NULL);
 	if (IS_ERR(i8k_hwmon_dev)) {
 		err = PTR_ERR(i8k_hwmon_dev);
 		i8k_hwmon_dev = NULL;
diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index da8d994..2c5e061 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -418,7 +418,7 @@ nouveau_hwmon_init(struct drm_device *dev)
 	if (!pm->temp_get)
 		return -ENODEV;
 
-	hwmon_dev = hwmon_device_register(&dev->pdev->dev);
+	hwmon_dev = hwmon_device_register(&dev->pdev->dev, NULL);
 	if (IS_ERR(hwmon_dev)) {
 		ret = PTR_ERR(hwmon_dev);
 		NV_ERROR(dev,
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 6fabe89..142eb83 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -489,7 +489,7 @@ static int radeon_hwmon_init(struct radeon_device *rdev)
 	case THERMAL_TYPE_EVERGREEN:
 	case THERMAL_TYPE_NI:
 	case THERMAL_TYPE_SUMO:
-		rdev->pm.int_hwmon_dev = hwmon_device_register(rdev->dev);
+		rdev->pm.int_hwmon_dev = hwmon_device_register(rdev->dev, NULL);
 		if (IS_ERR(rdev->pm.int_hwmon_dev)) {
 			err = PTR_ERR(rdev->pm.int_hwmon_dev);
 			dev_err(rdev->dev,
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 65a35cf..736d553 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1289,7 +1289,7 @@ static int __devinit abituguru_probe(struct platform_device *pdev)
 				&abituguru_sysfs_attr[i].dev_attr))
 			goto abituguru_probe_error;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (!IS_ERR(data->hwmon_dev))
 		return 0; /* success */
 
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index d30855a..fadc255 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -1000,7 +1000,7 @@ static int __devinit abituguru3_probe(struct platform_device *pdev)
 				&abituguru3_sysfs_attr[i].dev_attr))
 			goto abituguru3_probe_error;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		res = PTR_ERR(data->hwmon_dev);
 		goto abituguru3_probe_error;
diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 66f6729..1b970ee 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -914,7 +914,7 @@ static int acpi_power_meter_add(struct acpi_device *device)
 	if (res)
 		goto exit_free;
 
-	resource->hwmon_dev = hwmon_device_register(&device->dev);
+	resource->hwmon_dev = hwmon_device_register(&device->dev, NULL);
 	if (IS_ERR(resource->hwmon_dev)) {
 		res = PTR_ERR(resource->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index d46c0c7..43b8ea0 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -212,7 +212,7 @@ static int ad7414_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ad7418.c b/drivers/hwmon/ad7418.c
index ffc781f..5d49d4f 100644
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -273,7 +273,7 @@ static int ad7418_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &data->attrs)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index b2cacbe..2371760 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -192,7 +192,7 @@ static int __devinit adcxx_probe(struct spi_device *spi)
 		}
 	}
 
-	adc->hwmon_dev = hwmon_device_register(&spi->dev);
+	adc->hwmon_dev = hwmon_device_register(&spi->dev, NULL);
 	if (IS_ERR(adc->hwmon_dev)) {
 		dev_err(&spi->dev, "hwmon_device_register failed.\n");
 		status = PTR_ERR(adc->hwmon_dev);
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 1ad0a88..be7f0f0 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -364,7 +364,7 @@ static int adm1021_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &adm1021_group)))
 		goto error1;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error3;
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 60befc0..c2ab20e 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -473,7 +473,7 @@ static int adm1025_probe(struct i2c_client *client,
 			goto exit_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 0531867..adb6765 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -1727,7 +1727,7 @@ static int adm1026_probe(struct i2c_client *client,
 	if (err)
 		goto exitremove;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exitremove;
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 0b8a3b1..355fcb6 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -358,7 +358,7 @@ static int adm1029_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &adm1029_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 0683e6b..18aa7de 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -928,7 +928,7 @@ static int adm1031_probe(struct i2c_client *client,
 			goto exit_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index 9e234b9..5bbf727 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -635,7 +635,7 @@ static int adm9240_probe(struct i2c_client *new_client,
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &adm9240_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index e9beeda..296df5a 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -287,7 +287,7 @@ static int ads1015_probe(struct i2c_client *client,
 			goto exit_free;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index c42c5a6..3a31f6c 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -236,7 +236,7 @@ static int ads7828_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index 5231934..3b2dcbd 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -198,7 +198,7 @@ static int __devinit ads7871_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, pdata);
 
-	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
+	pdata->hwmon_dev = hwmon_device_register(&spi->dev, NULL);
 	if (IS_ERR(pdata->hwmon_dev)) {
 		err = PTR_ERR(pdata->hwmon_dev);
 		goto error_remove;
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index 5cc3e37..ad0947e 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -303,7 +303,7 @@ static int __devinit adt7411_probe(struct i2c_client *client,
 	if (ret)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 2af0c7b..7bd45e0 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -1949,7 +1949,7 @@ static int adt7462_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index c6d1ce0..a670df1 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1279,7 +1279,7 @@ static int adt7470_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &data->attrs)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index b5fcd87..c37590f 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1361,7 +1361,7 @@ static int adt7475_probe(struct i2c_client *client,
 			goto eremove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto eremove;
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 4033974..caf16a8 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -881,7 +881,7 @@ static int amc6821_probe(
 	if (err)
 		goto err_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (!IS_ERR(data->hwmon_dev))
 		return 0;
 
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4c07436..cf42ec0 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1275,7 +1275,7 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_light_sysfs;
 
-	hwmon_dev = hwmon_device_register(&pdev->dev);
+	hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(hwmon_dev)) {
 		ret = PTR_ERR(hwmon_dev);
 		goto out_light_ledclass;
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index c02a052..23d033f 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -771,7 +771,7 @@ static int asb100_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &asb100_group)))
 		goto ERROR3;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
diff --git a/drivers/hwmon/asc7621.c b/drivers/hwmon/asc7621.c
index d2596ce..a96de41 100644
--- a/drivers/hwmon/asc7621.c
+++ b/drivers/hwmon/asc7621.c
@@ -1127,7 +1127,7 @@ asc7621_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto exit_remove;
 	}
 
-	data->class_dev = hwmon_device_register(&client->dev);
+	data->class_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->class_dev)) {
 		err = PTR_ERR(data->class_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index 00e9851..d5e6c29 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -1239,7 +1239,7 @@ static int atk_register_hwmon(struct atk_data *data)
 	int err;
 
 	dev_dbg(dev, "registering hwmon device\n");
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev))
 		return PTR_ERR(data->hwmon_dev);
 
diff --git a/drivers/hwmon/atxp1.c b/drivers/hwmon/atxp1.c
index 33cc143..7a86314 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -336,7 +336,7 @@ static int atxp1_probe(struct i2c_client *new_client,
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &atxp1_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 4112576..10a811c 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -674,7 +674,7 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
 	pdata->phys_proc_id = TO_PHYS_ID(pdev->id);
 	platform_set_drvdata(pdev, pdata);
 
-	pdata->hwmon_dev = hwmon_device_register(&pdev->dev);
+	pdata->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(pdata->hwmon_dev)) {
 		err = PTR_ERR(pdata->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index d9c5927..16cc283 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -2428,7 +2428,7 @@ static int dme1737_i2c_probe(struct i2c_client *client,
 	}
 
 	/* Register device */
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(dev, "Failed to register device.\n");
 		err = PTR_ERR(data->hwmon_dev);
@@ -2637,7 +2637,7 @@ static int __devinit dme1737_isa_probe(struct platform_device *pdev)
 	}
 
 	/* Register device */
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(dev, "Failed to register device.\n");
 		err = PTR_ERR(data->hwmon_dev);
diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index e113634..8774e28 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -275,7 +275,7 @@ static int ds1621_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &ds1621_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/ds620.c b/drivers/hwmon/ds620.c
index 257957c..6344af5 100644
--- a/drivers/hwmon/ds620.c
+++ b/drivers/hwmon/ds620.c
@@ -271,7 +271,7 @@ static int ds620_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index cd2a6e4..e72c960 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -317,7 +317,7 @@ static int emc1403_probe(struct i2c_client *client,
 		dev_warn(&client->dev, "create group failed\n");
 		goto thermal_error1;
 	}
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		res = PTR_ERR(data->hwmon_dev);
 		dev_warn(&client->dev, "register hwmon dev failed\n");
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index af914ad..fbdf8bc 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -639,7 +639,7 @@ emc2103_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto exit_remove_temp3;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		status = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_temp4;
diff --git a/drivers/hwmon/emc6w201.c b/drivers/hwmon/emc6w201.c
index 0064432..1b9b628 100644
--- a/drivers/hwmon/emc6w201.c
+++ b/drivers/hwmon/emc6w201.c
@@ -507,7 +507,7 @@ static int emc6w201_probe(struct i2c_client *client,
 		goto exit_free;
 
 	/* Expose as a hwmon device */
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 92f9497..f014b2b 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -1388,7 +1388,7 @@ static int __devinit f71805f_probe(struct platform_device *pdev)
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 2d96ed2..79885a1 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2385,7 +2385,7 @@ no_pwm_auto_point:
 				 "duty-cycle" : "RPM");
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 95cbfb3..26523c3 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -647,7 +647,7 @@ static int f75375_probe(struct i2c_client *client,
 			goto exit_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 523f8fb..f1f1ea4 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -173,7 +173,7 @@ static int __devinit fam15h_power_probe(struct pci_dev *pdev,
 	if (err)
 		goto exit_free_data;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_group;
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index aa6d8b6..ed6b9c3 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -1150,7 +1150,7 @@ static int fschmd_probe(struct i2c_client *client,
 			goto exit_detach;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index 1d6a6fa..a66cc12 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -224,7 +224,7 @@ static int g760a_probe(struct i2c_client *client,
 	if (err)
 		goto error_sysfs_create_group;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_hwmon_device_register;
diff --git a/drivers/hwmon/gl518sm.c b/drivers/hwmon/gl518sm.c
index e7ae574..cc52daa 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -535,7 +535,7 @@ static int gl518_probe(struct i2c_client *client,
 					      &gl518_group_r80)))
 			goto exit_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index 131ea86..9af225c 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -747,7 +747,7 @@ static int gl520_probe(struct i2c_client *client,
 	}
 
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 89aa9fb..6e1ef7e 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -462,7 +462,7 @@ static int __devinit gpio_fan_probe(struct platform_device *pdev)
 		goto err_free_ctrl;
 
 	/* Make this driver part of hwmon class. */
-	fan_data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	fan_data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(fan_data->hwmon_dev)) {
 		err = PTR_ERR(fan_data->hwmon_dev);
 		goto err_remove_name;
diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index d22f241..5fe077a 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -379,7 +379,7 @@ static int __devinit i5k_amb_hwmon_init(struct platform_device *pdev)
 	if (res)
 		goto exit_remove;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		res = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index c316294..c2cc112 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -607,7 +607,7 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 		goto ipmi_err;
 
 	/* Register with hwmon */
-	data->hwmon_dev = hwmon_device_register(&data->pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&data->pdev->dev, NULL);
 
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(&data->pdev->dev, "Unable to register hwmon "
@@ -740,7 +740,7 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 		goto ipmi_err;
 
 	/* Register with hwmon */
-	data->hwmon_dev = hwmon_device_register(&data->pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&data->pdev->dev, NULL);
 
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(&data->pdev->dev, "Unable to register hwmon "
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 41dbf81..c20eb60 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -497,7 +497,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 		goto out_user;
 
 	/* Register the BMC as a HWMON class device */
-	data->hwmon_dev = hwmon_device_register(data->bmc_device);
+	data->hwmon_dev = hwmon_device_register(data->bmc_device, NULL);
 
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(data->bmc_device, "Unable to register hwmon "
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index d912649..1dd21b7 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1897,7 +1897,7 @@ static int __devinit it87_probe(struct platform_device *pdev)
 			goto ERROR4;
 	}
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 02cebb7..ad6feeb 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -513,7 +513,7 @@ static int jc42_probe(struct i2c_client *new_client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index fea292d..1c7f4b5 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -162,7 +162,7 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
-	hwmon->hwmon = hwmon_device_register(&pdev->dev);
+	hwmon->hwmon = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(hwmon->hwmon)) {
 		ret = PTR_ERR(hwmon->hwmon);
 		goto err_remove_file;
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 41aa6a3..be8d28a 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -168,7 +168,7 @@ static int __devinit k10temp_probe(struct pci_dev *pdev,
 	if (err)
 		goto exit_remove;
 
-	hwmon_dev = hwmon_device_register(&pdev->dev);
+	hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(hwmon_dev)) {
 		err = PTR_ERR(hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index b923bc2..a47f724 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -287,7 +287,7 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 	if (err)
 		goto exit_remove;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index 58eded2..1694911 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -522,7 +522,7 @@ static int pem_probe(struct i2c_client *client,
 			goto out_remove_groups;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_remove_groups;
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index 508cb29..80880c7 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -527,7 +527,7 @@ static int lm63_probe(struct i2c_client *new_client,
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index c274ea2..e698fd1 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -157,7 +157,7 @@ static int __devinit lm70_probe(struct spi_device *spi)
 	p_lm70->chip = chip;
 
 	/* sysfs hook */
-	p_lm70->hwmon_dev = hwmon_device_register(&spi->dev);
+	p_lm70->hwmon_dev = hwmon_device_register(&spi->dev, NULL);
 	if (IS_ERR(p_lm70->hwmon_dev)) {
 		dev_dbg(&spi->dev, "hwmon_device_register failed.\n");
 		status = PTR_ERR(p_lm70->hwmon_dev);
diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 29b9030..6228d05 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -113,7 +113,7 @@ lm73_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (status)
 		return status;
 
-	hwmon_dev = hwmon_device_register(&client->dev);
+	hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(hwmon_dev)) {
 		status = PTR_ERR(hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index ef902d5..88a2fe2 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -183,7 +183,7 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (status)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		status = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/lm77.c b/drivers/hwmon/lm77.c
index b28a297..034a5d5 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -333,7 +333,7 @@ static int lm77_probe(struct i2c_client *new_client,
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm77_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index 6df0b46..c3169b9 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -624,7 +624,7 @@ static int lm78_i2c_probe(struct i2c_client *client,
 	if (err)
 		goto ERROR3;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
@@ -827,7 +827,7 @@ static int __devinit lm78_isa_probe(struct platform_device *pdev)
 	 || (err = device_create_file(&pdev->dev, &dev_attr_name)))
 		goto exit_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index 18a0e6c..fa52d24 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -493,7 +493,7 @@ static int lm80_probe(struct i2c_client *client,
 	if ((err = sysfs_create_group(&client->dev.kobj, &lm80_group)))
 		goto error_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove;
diff --git a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
index 8290476..ddc5bd1 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -364,7 +364,7 @@ static int lm83_probe(struct i2c_client *new_client,
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index da72dc1..40e2b6d 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1357,7 +1357,7 @@ static int lm85_probe(struct i2c_client *client,
 					&lm85_group_in567)))
 			goto err_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto err_remove_files;
diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index f1e6e75..5a6606d 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -811,7 +811,7 @@ static int lm87_probe(struct i2c_client *new_client,
 			goto exit_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 90ddb87..05ed533 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1432,7 +1432,7 @@ static int lm90_probe(struct i2c_client *new_client,
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 7c31e62..ed7a7b9 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -365,7 +365,7 @@ static int lm92_probe(struct i2c_client *new_client,
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm92_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index 3b43df4..d83a27e 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2592,7 +2592,7 @@ static int lm93_probe(struct i2c_client *client,
 		goto err_free;
 
 	/* Register hwmon driver class */
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if ( !IS_ERR(data->hwmon_dev))
 		return 0;
 
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 513901d..4558b77 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -408,7 +408,7 @@ static int lm95241_probe(struct i2c_client *new_client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index dce9e68..d7db1f6 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -479,7 +479,7 @@ static int lm95245_probe(struct i2c_client *new_client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/ltc4151.c b/drivers/hwmon/ltc4151.c
index 4ac06b7..1561f03 100644
--- a/drivers/hwmon/ltc4151.c
+++ b/drivers/hwmon/ltc4151.c
@@ -194,7 +194,7 @@ static int ltc4151_probe(struct i2c_client *client,
 	if (ret)
 		goto out_sysfs_create_group;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_hwmon_device_register;
diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index c7e6d8e..8e20eaa 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -265,7 +265,7 @@ static int ltc4215_probe(struct i2c_client *client,
 	if (ret)
 		goto out_sysfs_create_group;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_hwmon_device_register;
diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index 6593083..93b365b 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -535,7 +535,7 @@ static int ltc4245_probe(struct i2c_client *client,
 	if (ret)
 		goto out_sysfs_create_groups;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_hwmon_device_register;
diff --git a/drivers/hwmon/ltc4261.c b/drivers/hwmon/ltc4261.c
index 4b50601..f53fd0b 100644
--- a/drivers/hwmon/ltc4261.c
+++ b/drivers/hwmon/ltc4261.c
@@ -251,7 +251,7 @@ static int ltc4261_probe(struct i2c_client *client,
 	if (ret)
 		goto out_sysfs_create_group;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_hwmon_device_register;
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index c97b78e..01c936b 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -185,7 +185,7 @@ static int __devinit max1111_probe(struct spi_device *spi)
 		goto err_free_data;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&spi->dev);
+	data->hwmon_dev = hwmon_device_register(&spi->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		dev_err(&spi->dev, "failed to create hwmon device\n");
 		err = PTR_ERR(data->hwmon_dev);
diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index dd2d7b9..fa8220a 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -652,7 +652,7 @@ static int max16065_probe(struct i2c_client *client,
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (unlikely(IS_ERR(data->hwmon_dev))) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out;
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index 022ded0..4b74756 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -278,7 +278,7 @@ static int max1619_probe(struct i2c_client *new_client,
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &max1619_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 20d1b2d..0eeec22 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -431,7 +431,7 @@ static int max1668_probe(struct i2c_client *client,
 			goto error_sysrem0;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_sysrem1;
diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index f20d997..465172d 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -565,7 +565,7 @@ static int max6639_probe(struct i2c_client *client,
 	if (err)
 		goto error_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove;
diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index e855d3b..d3a40f1 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -303,7 +303,7 @@ static int max6642_probe(struct i2c_client *new_client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index ece3aaf..3a35a47 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -555,7 +555,7 @@ static int max6650_probe(struct i2c_client *client,
 			goto err_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (!IS_ERR(data->hwmon_dev))
 		return 0;
 
diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index d5226c9..81ab9c8 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -176,7 +176,7 @@ static int __init mc13783_adc_probe(struct platform_device *pdev)
 			goto out_err_create2;
 	}
 
-	priv->hwmon_dev = hwmon_device_register(&pdev->dev);
+	priv->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(priv->hwmon_dev)) {
 		ret = PTR_ERR(priv->hwmon_dev);
 		dev_err(&pdev->dev,
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index eab1161..764af4e 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -309,7 +309,7 @@ static struct attribute *ntc_attributes[] = {
 	NULL,
 };
 
-static const struct attribute_group ntc_attr_group = {
+static struct attribute_group ntc_attr_group = {
 	.attrs = ntc_attributes,
 };
 
@@ -376,25 +376,17 @@ static int __devinit ntc_thermistor_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	ret = sysfs_create_group(&data->dev->kobj, &ntc_attr_group);
-	if (ret) {
-		dev_err(data->dev, "unable to create sysfs files\n");
-		goto err;
-	}
-
-	data->hwmon_dev = hwmon_device_register(data->dev);
+	data->hwmon_dev = hwmon_device_register(data->dev, &ntc_attr_group);
 	if (IS_ERR_OR_NULL(data->hwmon_dev)) {
 		dev_err(data->dev, "unable to register as hwmon device.\n");
 		ret = -EINVAL;
-		goto err_after_sysfs;
+		goto err;
 	}
 
 	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
 			pdev->name, pdev->id, pdev->id_entry->name,
 			pdev->id_entry->driver_data);
 	return 0;
-err_after_sysfs:
-	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
 err:
 	kfree(data);
 	return ret;
@@ -405,7 +397,6 @@ static int __devexit ntc_thermistor_remove(struct platform_device *pdev)
 	struct ntc_data *data = platform_get_drvdata(pdev);
 
 	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
 	platform_set_drvdata(pdev, NULL);
 
 	kfree(data);
diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index 3d99b88..7c0a398 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -1240,7 +1240,7 @@ static int __devinit pc87360_probe(struct platform_device *pdev)
 	if ((err = device_create_file(dev, &dev_attr_name)))
 		goto ERROR3;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR3;
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 8da2181..a5f738b 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -1125,7 +1125,7 @@ static int __devinit pc87427_probe(struct platform_device *pdev)
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
diff --git a/drivers/hwmon/pcf8591.c b/drivers/hwmon/pcf8591.c
index 731b09a..3a8d5c7 100644
--- a/drivers/hwmon/pcf8591.c
+++ b/drivers/hwmon/pcf8591.c
@@ -204,7 +204,7 @@ static int pcf8591_probe(struct i2c_client *client,
 			goto exit_sysfs_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_sysfs_remove;
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 397fc59..6829432 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1740,7 +1740,7 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		dev_err(&client->dev, "Failed to create sysfs entries\n");
 		goto out_attributes;
 	}
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		dev_err(&client->dev, "Failed to register hwmon device\n");
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index b39f52e..3a55f99 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -315,7 +315,7 @@ static int __devinit s3c_hwmon_probe(struct platform_device *dev)
 
 	/* register with the hwmon core */
 
-	hwmon->hwmon_dev = hwmon_device_register(&dev->dev);
+	hwmon->hwmon_dev = hwmon_device_register(&dev->dev, NULL);
 	if (IS_ERR(hwmon->hwmon_dev)) {
 		dev_err(&dev->dev, "error registering with hwmon\n");
 		ret = PTR_ERR(hwmon->hwmon_dev);
diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index e3b5c60..8e0cef1 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -567,7 +567,7 @@ static int __devinit sch5627_probe(struct platform_device *pdev)
 	if (err)
 		goto error;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/sch5636.c b/drivers/hwmon/sch5636.c
index 244407a..89a1dde 100644
--- a/drivers/hwmon/sch5636.c
+++ b/drivers/hwmon/sch5636.c
@@ -498,7 +498,7 @@ static int __devinit sch5636_probe(struct platform_device *pdev)
 			goto error;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index fe4104c..b4f3241 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -983,7 +983,7 @@ static int __devinit sht15_probe(struct platform_device *pdev)
 		goto err_release_irq;
 	}
 
-	data->hwmon_dev = hwmon_device_register(data->dev);
+	data->hwmon_dev = hwmon_device_register(data->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto err_release_sysfs_group;
diff --git a/drivers/hwmon/sht21.c b/drivers/hwmon/sht21.c
index 1c8c981..86c3a9e 100644
--- a/drivers/hwmon/sht21.c
+++ b/drivers/hwmon/sht21.c
@@ -231,7 +231,7 @@ static int __devinit sht21_probe(struct i2c_client *client,
 		dev_dbg(&client->dev, "could not create sysfs files\n");
 		goto fail_free;
 	}
-	sht21->hwmon_dev = hwmon_device_register(&client->dev);
+	sht21->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(sht21->hwmon_dev)) {
 		dev_dbg(&client->dev, "unable to register hwmon device\n");
 		err = PTR_ERR(sht21->hwmon_dev);
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 47d7ce9..fb39be4 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -583,7 +583,7 @@ static int __devinit sis5595_probe(struct platform_device *pdev)
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
index 425df5b..5e11aea 100644
--- a/drivers/hwmon/smm665.c
+++ b/drivers/hwmon/smm665.c
@@ -673,7 +673,7 @@ static int smm665_probe(struct i2c_client *client,
 	if (ret)
 		goto out_unregister;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto out_remove_group;
diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index 9fb7516..2b96913 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -279,7 +279,7 @@ static int __devinit smsc47b397_probe(struct platform_device *pdev)
 	if ((err = sysfs_create_group(&dev->kobj, &smsc47b397_group)))
 		goto error_free;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove;
diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index f44a89a..f748865 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -723,7 +723,7 @@ static int __init smsc47m1_probe(struct platform_device *pdev)
 	if ((err = device_create_file(dev, &dev_attr_name)))
 		goto error_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove_files;
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index 40b2667..6b8d9b5 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -543,7 +543,7 @@ static int smsc47m192_probe(struct i2c_client *client,
 			goto exit_remove_files;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/thmc50.c b/drivers/hwmon/thmc50.c
index 7dfb4de..2d44779 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -370,7 +370,7 @@ static int thmc50_probe(struct i2c_client *client,
 			goto exit_remove_sysfs_thmc50;
 
 	/* Register a new directory entry with module sensors */
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_sysfs;
diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 5bd1949..ec756e5 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -208,7 +208,7 @@ static int __devinit tmp102_probe(struct i2c_client *client,
 		dev_dbg(&client->dev, "could not create sysfs files\n");
 		goto fail_restore_config;
 	}
-	tmp102->hwmon_dev = hwmon_device_register(&client->dev);
+	tmp102->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(tmp102->hwmon_dev)) {
 		dev_dbg(&client->dev, "unable to register hwmon device\n");
 		status = PTR_ERR(tmp102->hwmon_dev);
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index ad8d535..08b13c3 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -634,7 +634,7 @@ static int tmp401_probe(struct i2c_client *client,
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index 0517a8f..a97fadd 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -283,7 +283,7 @@ static int tmp421_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&client->dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		data->hwmon_dev = NULL;
diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 5724074..635703c 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -103,7 +103,7 @@ static int __devinit twl4030_madc_hwmon_probe(struct platform_device *pdev)
 	ret = sysfs_create_group(&pdev->dev.kobj, &twl4030_madc_group);
 	if (ret)
 		goto err_sysfs;
-	hwmon = hwmon_device_register(&pdev->dev);
+	hwmon = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(hwmon)) {
 		dev_err(&pdev->dev, "hwmon_device_register failed.\n");
 		ret = PTR_ERR(hwmon);
diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
index 27a6271..f549566 100644
--- a/drivers/hwmon/ultra45_env.c
+++ b/drivers/hwmon/ultra45_env.c
@@ -252,7 +252,7 @@ static int __devinit env_probe(struct platform_device *op)
 	if (err)
 		goto out_iounmap;
 
-	p->hwmon_dev = hwmon_device_register(&op->dev);
+	p->hwmon_dev = hwmon_device_register(&op->dev, NULL);
 	if (IS_ERR(p->hwmon_dev)) {
 		err = PTR_ERR(p->hwmon_dev);
 		goto out_sysfs_remove_group;
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8eac67d..095e318 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -177,7 +177,7 @@ static int __devinit via_cputemp_probe(struct platform_device *pdev)
 			goto exit_remove;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n",
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index 25e9166..f2340d0 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -658,7 +658,7 @@ static int __devinit via686a_probe(struct platform_device *pdev)
 	if ((err = sysfs_create_group(&pdev->dev.kobj, &via686a_group)))
 		goto exit_free;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 49163d4..f1119d4 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -1198,7 +1198,7 @@ static int __devinit vt1211_probe(struct platform_device *pdev)
 	}
 
 	/* Register device */
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		dev_err(dev, "Class registration failed (%d)\n", err);
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index db3b2e8..2924e6a 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -765,7 +765,7 @@ static int vt8231_probe(struct platform_device *pdev)
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index f2b377c..4e94e47 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2265,7 +2265,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	if (err)
 		goto exit_remove;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index bde50e3..9646b92 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -1414,7 +1414,7 @@ static int __devinit w83627hf_probe(struct platform_device *pdev)
 				&sensor_dev_attr_pwm3_enable.dev_attr)))
 			goto ERROR4;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index eed43a0..948e2f3 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1182,7 +1182,7 @@ w83781d_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (err)
 		goto ERROR4;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
@@ -1745,7 +1745,7 @@ w83781d_isa_probe(struct platform_device *pdev)
 	if (err)
 		goto exit_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 17cf1ab..35fd74e 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1352,7 +1352,7 @@ static int w83791d_probe(struct i2c_client *client,
 	}
 
 	/* Everything is ready, now register the working device */
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto error5;
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index f3e7130..a921c2c 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -1402,7 +1402,7 @@ w83792d_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					      &w83792d_group_fan[3])))
 			goto exit_remove_files;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 854f911..195b0ea 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1807,7 +1807,7 @@ static int w83793_probe(struct i2c_client *client,
 		}
 	}
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
index 845232d..a001282 100644
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -2197,7 +2197,7 @@ static int w83795_probe(struct i2c_client *client,
 	if (data->chip_type == w83795g)
 		w83795_check_dynamic_in_limits(client);
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/w83l785ts.c b/drivers/hwmon/w83l785ts.c
index 20781de..70b75d0 100644
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -212,7 +212,7 @@ static int w83l785ts_probe(struct i2c_client *new_client,
 		goto exit_remove;
 
 	/* Register sysfs hooks */
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 0254e18..cc9f87a 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -655,7 +655,7 @@ w83l786ng_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if ((err = sysfs_create_group(&client->dev.kobj, &w83l786ng_group)))
 		goto exit_remove;
 
-	data->hwmon_dev = hwmon_device_register(dev);
+	data->hwmon_dev = hwmon_device_register(dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
diff --git a/drivers/hwmon/wm831x-hwmon.c b/drivers/hwmon/wm831x-hwmon.c
index 97b1f83..93a2f5c 100644
--- a/drivers/hwmon/wm831x-hwmon.c
+++ b/drivers/hwmon/wm831x-hwmon.c
@@ -171,7 +171,7 @@ static int __devinit wm831x_hwmon_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	hwmon->classdev = hwmon_device_register(&pdev->dev);
+	hwmon->classdev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(hwmon->classdev)) {
 		ret = PTR_ERR(hwmon->classdev);
 		goto err_sysfs;
diff --git a/drivers/hwmon/wm8350-hwmon.c b/drivers/hwmon/wm8350-hwmon.c
index 1329059..147c21b 100644
--- a/drivers/hwmon/wm8350-hwmon.c
+++ b/drivers/hwmon/wm8350-hwmon.c
@@ -100,7 +100,7 @@ static int __devinit wm8350_hwmon_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	wm8350->hwmon.classdev = hwmon_device_register(&pdev->dev);
+	wm8350->hwmon.classdev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(wm8350->hwmon.classdev)) {
 		ret = PTR_ERR(wm8350->hwmon.classdev);
 		goto err_group;
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index d507b9b..52f10ac 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -546,7 +546,7 @@ static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
 	if (err)
 		return err;
 
-	hwmon = hwmon_device_register(&spi->dev);
+	hwmon = hwmon_device_register(&spi->dev, NULL);
 	if (IS_ERR(hwmon)) {
 		sysfs_remove_group(&spi->dev.kobj, ts->attr_group);
 		return PTR_ERR(hwmon);
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 95cba9e..d03d357 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1055,7 +1055,7 @@ static int asus_wmi_hwmon_init(struct asus_wmi *asus)
 	struct device *hwmon;
 	int result;
 
-	hwmon = hwmon_device_register(&asus->platform_device->dev);
+	hwmon = hwmon_device_register(&asus->platform_device->dev, NULL);
 	if (IS_ERR(hwmon)) {
 		pr_err("Could not register asus hwmon device\n");
 		return PTR_ERR(hwmon);
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 8877b83..63bdbd6 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1035,7 +1035,7 @@ static int __devinit compal_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev, NULL);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		sysfs_remove_group(&pdev->dev.kobj,
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 1c45d92..973d031 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1116,7 +1116,7 @@ static int eeepc_hwmon_init(struct eeepc_laptop *eeepc)
 	struct device *hwmon;
 	int result;
 
-	hwmon = hwmon_device_register(&eeepc->platform_device->dev);
+	hwmon = hwmon_device_register(&eeepc->platform_device->dev, NULL);
 	if (IS_ERR(hwmon)) {
 		pr_err("Could not register eeepc hwmon device\n");
 		eeepc->hwmon_device = NULL;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7bd829f..26c4d90 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9077,7 +9077,7 @@ static int __init thinkpad_acpi_module_init(void)
 		return ret;
 	}
 	tp_features.sensors_pdev_attrs_registered = 1;
-	tpacpi_hwmon = hwmon_device_register(&tpacpi_sensors_pdev->dev);
+	tpacpi_hwmon = hwmon_device_register(&tpacpi_sensors_pdev->dev, NULL);
 	if (IS_ERR(tpacpi_hwmon)) {
 		ret = PTR_ERR(tpacpi_hwmon);
 		tpacpi_hwmon = NULL;
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 708f8e9..2be2519 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -548,7 +548,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 
 	INIT_LIST_HEAD(&hwmon->tz_list);
 	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
-	hwmon->device = hwmon_device_register(NULL);
+	hwmon->device = hwmon_device_register(NULL, NULL);
 	if (IS_ERR(hwmon->device)) {
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
-- 
1.7.4.1

