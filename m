Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab2LIBN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 20:13:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:34920 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2LIBNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 20:13:22 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] Revert "HID: sensors: add to special driver list"
Date: Sun,  9 Dec 2012 02:12:24 +0100
Message-Id: <1355015544-31579-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355015544-31579-1-git-send-email-holler@ahsoftware.de>
References: <1355015544-31579-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those IDs aren't necessary anymore.

This reverts commit c8147d9ea19bfe7d8e569351bc7239e118dd6997.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/hid/hid-core.c |    5 -----
 drivers/hid/hid-ids.h  |    6 ------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2085230..943a6bc 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1579,10 +1579,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK, USB_DEVICE_ID_HOLTEK_ON_LINE_GRIP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8086, USB_DEVICE_ID_SENSOR_HUB_1020) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8086, USB_DEVICE_ID_SENSOR_HUB_09FA) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8087, USB_DEVICE_ID_SENSOR_HUB_1020) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8087, USB_DEVICE_ID_SENSOR_HUB_09FA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
@@ -1680,7 +1676,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM, USB_DEVICE_ID_SENSOR_HUB_7014) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9d7a428..8fd25d3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -432,11 +432,6 @@
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
 
-#define USB_VENDOR_ID_INTEL_8086	0x8086
-#define USB_VENDOR_ID_INTEL_8087	0x8087
-#define USB_DEVICE_ID_SENSOR_HUB_1020	0x1020
-#define USB_DEVICE_ID_SENSOR_HUB_09FA	0x09FA
-
 #define USB_VENDOR_ID_IRTOUCHSYSTEMS	0x6615
 #define USB_DEVICE_ID_IRTOUCH_INFRARED_USB	0x0070
 
@@ -714,7 +709,6 @@
 
 #define USB_VENDOR_ID_STANTUM_STM		0x0483
 #define USB_DEVICE_ID_MTP_STM		0x3261
-#define USB_DEVICE_ID_SENSOR_HUB_7014	0x7014
 
 #define USB_VENDOR_ID_STANTUM_SITRONIX		0x1403
 #define USB_DEVICE_ID_MTP_SITRONIX		0x5001
-- 
1.7.8.6

