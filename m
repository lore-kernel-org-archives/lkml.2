Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab2LIMWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:22:51 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50215 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977Ab2LIMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:22:49 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/3] iio: Add Usage IDs for HID time sensors.
Date: Sun,  9 Dec 2012 13:21:38 +0100
Message-Id: <1355055699-2965-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355055699-2965-1-git-send-email-holler@ahsoftware.de>
References: <1355055699-2965-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are Usage IDs for the attributes year, month, day,
hour, minute and second, needed to read HID time sensors.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 include/linux/hid-sensor-ids.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/hid-sensor-ids.h b/include/linux/hid-sensor-ids.h
index 55f2773..6f24446 100644
--- a/include/linux/hid-sensor-ids.h
+++ b/include/linux/hid-sensor-ids.h
@@ -66,6 +66,15 @@
 #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS		0x200486
 #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS		0x200487
 
+/* Time (2000a0) */
+#define HID_USAGE_SENSOR_TIME					0x2000a0
+#define HID_USAGE_SENSOR_TIME_YEAR				0x200521
+#define HID_USAGE_SENSOR_TIME_MONTH				0x200522
+#define HID_USAGE_SENSOR_TIME_DAY				0x200523
+#define HID_USAGE_SENSOR_TIME_HOUR				0x200525
+#define HID_USAGE_SENSOR_TIME_MINUTE				0x200526
+#define HID_USAGE_SENSOR_TIME_SECOND				0x200527
+
 /* Units */
 #define HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED			0x00
 #define HID_USAGE_SENSOR_UNITS_LUX				0x01
-- 
1.7.8.6

