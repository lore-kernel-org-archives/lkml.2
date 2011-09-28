Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1I1Wh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab1I1WhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.129627125@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Gavin.zhu" <gavin.kx@qq.com>
Subject: [018/244] USB: option: add YUGA device id to driver
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Gavin.zhu" <gavin.kx@qq.com>

commit c6eb2d75ffcdfafa37ff010bf467de20d468ef79 upstream.

Signed-off-by: Gavin.zhu <gavin.kx@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   92 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -418,6 +418,56 @@ static void option_instat_callback(struc
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
 
+/* YUGA products  www.yuga-info.com*/
+#define YUGA_VENDOR_ID				0x257A
+#define YUGA_PRODUCT_CEM600			0x1601
+#define YUGA_PRODUCT_CEM610			0x1602
+#define YUGA_PRODUCT_CEM500			0x1603
+#define YUGA_PRODUCT_CEM510			0x1604
+#define YUGA_PRODUCT_CEM800			0x1605
+#define YUGA_PRODUCT_CEM900			0x1606
+
+#define YUGA_PRODUCT_CEU818			0x1607
+#define YUGA_PRODUCT_CEU816			0x1608
+#define YUGA_PRODUCT_CEU828			0x1609
+#define YUGA_PRODUCT_CEU826			0x160A
+#define YUGA_PRODUCT_CEU518			0x160B
+#define YUGA_PRODUCT_CEU516			0x160C
+#define YUGA_PRODUCT_CEU528			0x160D
+#define YUGA_PRODUCT_CEU526			0x160F
+
+#define YUGA_PRODUCT_CWM600			0x2601
+#define YUGA_PRODUCT_CWM610			0x2602
+#define YUGA_PRODUCT_CWM500			0x2603
+#define YUGA_PRODUCT_CWM510			0x2604
+#define YUGA_PRODUCT_CWM800			0x2605
+#define YUGA_PRODUCT_CWM900			0x2606
+
+#define YUGA_PRODUCT_CWU718			0x2607
+#define YUGA_PRODUCT_CWU716			0x2608
+#define YUGA_PRODUCT_CWU728			0x2609
+#define YUGA_PRODUCT_CWU726			0x260A
+#define YUGA_PRODUCT_CWU518			0x260B
+#define YUGA_PRODUCT_CWU516			0x260C
+#define YUGA_PRODUCT_CWU528			0x260D
+#define YUGA_PRODUCT_CWU526			0x260F
+
+#define YUGA_PRODUCT_CLM600			0x2601
+#define YUGA_PRODUCT_CLM610			0x2602
+#define YUGA_PRODUCT_CLM500			0x2603
+#define YUGA_PRODUCT_CLM510			0x2604
+#define YUGA_PRODUCT_CLM800			0x2605
+#define YUGA_PRODUCT_CLM900			0x2606
+
+#define YUGA_PRODUCT_CLU718			0x2607
+#define YUGA_PRODUCT_CLU716			0x2608
+#define YUGA_PRODUCT_CLU728			0x2609
+#define YUGA_PRODUCT_CLU726			0x260A
+#define YUGA_PRODUCT_CLU518			0x260B
+#define YUGA_PRODUCT_CLU516			0x260C
+#define YUGA_PRODUCT_CLU528			0x260D
+#define YUGA_PRODUCT_CLU526			0x260F
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1009,6 +1059,48 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM610) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM500) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM510) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM800) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM900) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU818) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU816) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU828) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU826) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU518) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU516) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU528) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU526) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM600) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM610) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM500) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM510) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM800) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWM900) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU718) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU716) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU728) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU726) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU518) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU516) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU528) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU526) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM600) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM610) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM500) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM510) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM800) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLM900) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU718) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU716) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU728) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU726) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU518) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU516) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU528) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


