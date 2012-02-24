Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2BXGlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:41:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2BXGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:41:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of missingsailor@gmail.com designates 10.180.93.232 as permitted sender) smtp.mail=missingsailor@gmail.com; dkim=pass header.i=missingsailor@gmail.com
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 14:41:04 +0800
X-Google-Sender-Auth: rooPD_qOPHiH43ikjzEldnPTuU0
Message-ID: <CACwCHpxjhEenzv+H3zK2cNKAA9KyuK=DPythY2UgHTmY_AhqaQ@mail.gmail.com>
Subject: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
From: meng zhang <meng.zhang@mediatek.com>
To: smurf@smurf.noris.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Meng Zhang <meng.zhang@mediatek.com>

1. This patch is based on kernel 3.0.0
2. To declare the product IDs in option.c

Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
---------------------------------------------------------------------------------------

--- option.c	2012-02-23 10:42:40.635138657 +0800
+++ option.c.orig	2011-10-07 22:50:04.000000000 +0800
@@ -416,9 +416,6 @@ static void option_instat_callback(struc
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889

-/* MediaTek products */
-#define MEDIATEK_VENDOR_ID				0x0e8d
-
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1008,10 +1005,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650
CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID,
SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /*
Samsung GT-B3730 LTE USB modem.*/
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
0x00, 0x00) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
0x02, 0x01) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x00, 0x00) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x02, 0x01) },	/* MediaTek MT6276M modem & app port */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
