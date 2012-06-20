Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2FTSY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:24:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab2FTSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:22 -0400
Message-Id: <20120620173040.088664859@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gavin zhu <gavin.zhu@qq.com>
Subject: [ 06/20] USB: option: add more YUGA device ids
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?=E8=AF=B4=E4=B8=8D=E5=BE=97?= <gavin.kx@qq.com>

commit 0ef0be15fd2564767f114c249fc4af704d8e16f4 upstream.

Signed-off-by: gavin zhu <gavin.zhu@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -426,7 +426,7 @@ static void option_instat_callback(struc
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
 
-/* YUGA products  www.yuga-info.com*/
+/* YUGA products  www.yuga-info.com gavin.kx@qq.com */
 #define YUGA_VENDOR_ID				0x257A
 #define YUGA_PRODUCT_CEM600			0x1601
 #define YUGA_PRODUCT_CEM610			0x1602
@@ -443,6 +443,8 @@ static void option_instat_callback(struc
 #define YUGA_PRODUCT_CEU516			0x160C
 #define YUGA_PRODUCT_CEU528			0x160D
 #define YUGA_PRODUCT_CEU526			0x160F
+#define YUGA_PRODUCT_CEU881			0x161F
+#define YUGA_PRODUCT_CEU882			0x162F
 
 #define YUGA_PRODUCT_CWM600			0x2601
 #define YUGA_PRODUCT_CWM610			0x2602
@@ -458,23 +460,26 @@ static void option_instat_callback(struc
 #define YUGA_PRODUCT_CWU518			0x260B
 #define YUGA_PRODUCT_CWU516			0x260C
 #define YUGA_PRODUCT_CWU528			0x260D
+#define YUGA_PRODUCT_CWU581			0x260E
 #define YUGA_PRODUCT_CWU526			0x260F
+#define YUGA_PRODUCT_CWU582			0x261F
+#define YUGA_PRODUCT_CWU583			0x262F
 
-#define YUGA_PRODUCT_CLM600			0x2601
-#define YUGA_PRODUCT_CLM610			0x2602
-#define YUGA_PRODUCT_CLM500			0x2603
-#define YUGA_PRODUCT_CLM510			0x2604
-#define YUGA_PRODUCT_CLM800			0x2605
-#define YUGA_PRODUCT_CLM900			0x2606
-
-#define YUGA_PRODUCT_CLU718			0x2607
-#define YUGA_PRODUCT_CLU716			0x2608
-#define YUGA_PRODUCT_CLU728			0x2609
-#define YUGA_PRODUCT_CLU726			0x260A
-#define YUGA_PRODUCT_CLU518			0x260B
-#define YUGA_PRODUCT_CLU516			0x260C
-#define YUGA_PRODUCT_CLU528			0x260D
-#define YUGA_PRODUCT_CLU526			0x260F
+#define YUGA_PRODUCT_CLM600			0x3601
+#define YUGA_PRODUCT_CLM610			0x3602
+#define YUGA_PRODUCT_CLM500			0x3603
+#define YUGA_PRODUCT_CLM510			0x3604
+#define YUGA_PRODUCT_CLM800			0x3605
+#define YUGA_PRODUCT_CLM900			0x3606
+
+#define YUGA_PRODUCT_CLU718			0x3607
+#define YUGA_PRODUCT_CLU716			0x3608
+#define YUGA_PRODUCT_CLU728			0x3609
+#define YUGA_PRODUCT_CLU726			0x360A
+#define YUGA_PRODUCT_CLU518			0x360B
+#define YUGA_PRODUCT_CLU516			0x360C
+#define YUGA_PRODUCT_CLU528			0x360D
+#define YUGA_PRODUCT_CLU526			0x360F
 
 /* Viettel products */
 #define VIETTEL_VENDOR_ID			0x2262
@@ -1213,6 +1218,11 @@ static const struct usb_device_id option
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU516) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU528) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU881) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU882) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU581) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU582) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU583) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */


