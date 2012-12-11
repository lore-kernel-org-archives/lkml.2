Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2LKSW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:22:56 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:38417 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2LKSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:22:55 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/4 RESEND] iio: Add Usage IDs for HID time sensors.
Date: Tue, 11 Dec 2012 19:21:44 +0100
Message-Id: <1355250106-3114-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355250106-3114-1-git-send-email-holler@ahsoftware.de>
References: <50C73AFC.1050904@jic23.retrosnub.co.uk>
 <1355250106-3114-1-git-send-email-holler@ahsoftware.de>
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
index ca8d7e9..3754ea9 100644
--- a/include/linux/hid-sensor-ids.h
+++ b/include/linux/hid-sensor-ids.h
@@ -67,6 +67,15 @@
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

