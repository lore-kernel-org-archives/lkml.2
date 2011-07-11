Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1GKGJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:09:14 -0400
Received: from accupoint.com.tw ([220.128.111.38]:23347 "EHLO
	exsvr1.accupoint.com.tw" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756568Ab1GKGJM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:09:12 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 02:09:12 EDT
Content-class: urn:content-classes:message
Subject: [PATCH] hid-multitouch driver: add one new hid multitouch device's VID/PID
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Jul 2011 13:59:16 +0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <C3F4720C7083254FAB01F1C177F02212098A1B@exsvr1.accupoint.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] hid-multitouch driver: add one new hid multitouch device's VID/PID
Thread-Index: Acw/iqk/Il3Rdr2xRmi9ohvpu6woTAAAnVkw
References: <[PATCH 2/2]Staging: comedi: fix brace coding style issue in pcl818.c> <1310362809-15273-1-git-send-email-ravishankarkm32@gmail.com>
From: "Ice.Chien" <ice.chien@accupoint.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: <benjamin.tissoires@enac.fr>, "Jonson Wu" <jonson.wu@accupoint.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to add one hid multitouch device's VID/PID in hid-ids.h
and hid-core.c

Signed-off-by: Ice Chien <ice.chien@accupoint.com.tw>
---
diff -u ./linux-2.6.39.3/drivers/hid//hid-core.c
./modified/drivers/hid//hid-core.c
--- ./linux-2.6.39.3/drivers/hid//hid-core.c	2011-07-09
14:16:06.000000000 +0800
+++ ./modified/drivers/hid//hid-core.c	2011-07-11 13:36:07.784957908
+0800
@@ -1482,6 +1482,7 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
+      	{ HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON,
USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
diff -u ./linux-2.6.39.3/drivers/hid//hid-ids.h
./modified/drivers/hid//hid-ids.h
--- ./linux-2.6.39.3/drivers/hid//hid-ids.h	2011-07-09
14:16:06.000000000 +0800
+++ ./modified/drivers/hid//hid-ids.h	2011-07-11 13:36:05.969865971
+0800
@@ -607,6 +607,9 @@
 #define USB_VENDOR_ID_WISEGROUP_LTD2	0x6677
 #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
 
+#define USB_VENDOR_ID_XAT               0x2505
+#define USB_DEVICE_ID_XAT_CSR           0x0220
+
 #define USB_VENDOR_ID_YEALINK		0x6993
 #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K	0xb001
 
Common subdirectories: ./linux-2.6.39.3/drivers/hid//usbhid and
./modified/drivers/hid//usbhid
