Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0JVL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:59:06 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:30082 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0JVL5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:50 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] hwmon: lis3: Short explanations of platform data fields
Date: Fri, 22 Oct 2010 14:57:33 +0300
Message-Id: <1287748654-2626-12-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short documentation at kernel doc format.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 include/linux/lis3lv02d.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index c949612..da294cd 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -1,6 +1,47 @@
 #ifndef __LIS3LV02D_H_
 #define __LIS3LV02D_H_
 
+/**
+ * struct lis3lv02d_platform_data - lis3 chip family platform data
+ * @click_flags:       Click detection unit configuration
+ * @click_thresh_x:    Click detection unit x axis treshold
+ * @click_thresh_y:    Click detection unit y axis treshold
+ * @click_thresh_z:    Click detection unit z axis treshold
+ * @click_time_limit:  Click detection unit time parameter
+ * @click_latency:     Click detection unit latency parameter
+ * @click_window:      Click detection unit window parameter
+ * @irq_cfg:	       On chip irq configuration (click / data available / wu)
+ * @irq_flags1:	       Additional irq triggering flags for irq channel 0
+ * @irq_flags2:	       Additional irq triggering flags for irq channel 1
+ * @duration1:	       Wake up unit 1 duration parameter
+ * @duration2:	       Wake up unit 2 duration parameter
+ * @wakeup_flags:      Wakeup unit 1 flags
+ * @wakeup_thresh:     Wakeup unit 1 threshold value
+ * @wakeup_flags2:     Wakeup unit 2 flags
+ * @wakeup_thresh2:    Wakeup unit 2 threshold value
+ * @hipass_ctrl:       Hi-pass filter control
+ * @axis_x:	       Remap parameter for x-axis
+ * @axis_y:	       Remap parameter for y-axis
+ * @axis_z:	       Remap parameter for z-axis
+ * @driver_features:   Enable bits for different features. Disabled by default
+ * @default_rate:      Default sampling rate. 0 means reset default
+ * @setup_resources:   Interrupt line setup call back function
+ * @release_resources: Interrupt line release call back function
+ * @st_min_limits[3]:  Selftest acceptance minimum values
+ * @st_max_limits[3]:  Selftest accepratnce maximum values
+ * @irq2:	       Irq line 2 number
+ *
+ * Platform data is used to setup the sensor chip. Meaning of the different
+ * chip features can be found from the data sheet. Currently the data is used
+ * only for the 8 bit device. The 8 bit device has two wake up / free fall
+ * detection units and click detection unit. There are plenty of ways to
+ * configure the chip which makes is quite impossible to explain meaning of the
+ * fields here. Behaviour of the detection blocks varies heavily depending
+ * on the configuration. Irq_flags can be used to enable interrupt detection
+ * on the both edges. With proper chip configuration this produces interrupt
+ * when some trigger starts and when it goes away.
+ */
+
 struct lis3lv02d_platform_data {
 	/* please note: the 'click' feature is only supported for
 	 * LIS[32]02DL variants of the chip and will be ignored for
-- 
1.6.0.4

