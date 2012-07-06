Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab2GFNux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:50:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36923 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2GFNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:50:51 -0400
MIME-Version: 1.0
Date: Fri, 6 Jul 2012 21:50:50 +0800
X-Google-Sender-Auth: PMqnFVP6RXBTQSXwiyilTG_y0es
Message-ID: <CAAwpLmyd2SMR0EKGowDqo54mPUuPmKkziGVTsuRZcrd7i2r2jA@mail.gmail.com>
Subject: USB: option: Add MEDIATEK product ids
From: gaosen <gaosen.zhang@mediatek.com>
To: smurf@smurf.noris.de, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 86fcd5bb701bd927d588386c480c37784d10040a Mon Sep 17 00:00:00 2001
From: Gaosen Zhang <gaosen.zhang@mediatek.com>
Date: Fri, 6 Jul 2012 21:44:10 +0800
Subject: [PATCH 1/1] USB: option: Add MEDIATEK product ids


Signed-off-by: Gaosen Zhang <gaosen.zhang@mediatek.com>
---
 drivers/usb/serial/option.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e668a24..f342a2c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -496,6 +496,15 @@ static void option_instat_callback(struct urb *urb);

 /* MediaTek products */
 #define MEDIATEK_VENDOR_ID			0x0e8d
+#define MTK_FP_1COM				0x0003
+#define MTK_FP_2COM				0x0023
+#define MTK_FPDC_2COM				0x0033
+#define MTK_FPDC_1COM				0x0043
+#define MTK_DC_1COM				0x00a0
+#define MTK_DC_5COM				0x00a4
+#define MTK_DC_4COM				0x00a5
+#define MTK_7208_1COM				0x7101
+#define MTK_7208_2COM				0x7102

 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
@@ -1233,6 +1242,17 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FP_1COM,
0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FP_2COM,
0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FPDC_1COM,
0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FPDC_2COM,
0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_1COM,
0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_5COM,
0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_5COM,
0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_4COM,
0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_4COM,
0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_7208_1COM,
0x02, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_7208_2COM,
0x02, 0x02, 0x01) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.7.9.5
