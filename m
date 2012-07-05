Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2GENt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:49:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46076 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2GENtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:49:01 -0400
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 21:49:00 +0800
X-Google-Sender-Auth: l3Vfl1D5d6N5mbiWX9jovgjESk8
Message-ID: <CAAwpLmyKrXk=RwNv2jmaqczJyzUz7TQ808EBr1AQdopor8KGjQ@mail.gmail.com>
Subject: Add MEDIATEK products to option driver
From: gaosen <gaosen.zhang@mediatek.com>
To: smurf@smurf.noris.de, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bb4d2a7155393b5d1207c398c3f9644898588e8a Mon Sep 17 00:00:00 2001
From: "gaosen.zhang" <gaosen.zhang@mediatek.com>
Date: Thu, 5 Jul 2012 20:01:54 +0800
Subject: [PATCH 1/1] Add MEDIATEK products to option driver


Signed-off-by: gaosen.zhang <gaosen.zhang@mediatek.com>
---
 drivers/usb/serial/option.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e668a24..3d47661 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -496,6 +496,15 @@ static void option_instat_callback(struct urb *urb);

 /* MediaTek products */
 #define MEDIATEK_VENDOR_ID			0x0e8d
+#define MEDIATEK_PRODUCT_DC_1COM		0x00a0
+#define MEDIATEK_PRODUCT_DC_4COM		0x00a5
+#define MEDIATEK_PRODUCT_DC_5COM		0x00a4
+#define MEDIATEK_PRODUCT_7208_1COM		0x7101
+#define MEDIATEK_PRODUCT_7208_2COM		0x7102
+#define MEDIATEK_PRODUCT_FP_1COM		0x0003
+#define MEDIATEK_PRODUCT_FP_2COM		0x0023
+#define MEDIATEK_PRODUCT_FPDC_1COM		0x0043
+#define MEDIATEK_PRODUCT_FPDC_2COM		0x0033

 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
@@ -1233,6 +1242,17 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_1COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_5COM, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_5COM, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_4COM, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_DC_4COM, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_7208_1COM, 0x02, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_7208_2COM, 0x02, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_FP_1COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_FP_2COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_FPDC_1COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
MEDIATEK_PRODUCT_FPDC_2COM, 0x0a, 0x00, 0x00) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.7.9.5
