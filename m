Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab2BAVRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36576 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932556Ab2BAVKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:17 -0500
X-Sasl-enc: dKC3k+x3eXICxphv1Y1QPE9B+SwqlRZROueCc1VviWao 1328130616
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.042250651@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [47/89] qcaux: add more Pantech UML190 and UML290 ports
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 074cc73506f529f39fef32ad1c9e1d4cdd8acf6c upstream.

More ports we now know how to talk to.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcaux.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -36,6 +36,7 @@
 #define UTSTARCOM_PRODUCT_UM175_V1		0x3712
 #define UTSTARCOM_PRODUCT_UM175_V2		0x3714
 #define UTSTARCOM_PRODUCT_UM175_ALLTEL		0x3715
+#define PANTECH_PRODUCT_UML190_VZW		0x3716
 #define PANTECH_PRODUCT_UML290_VZW		0x3718
 
 /* CMOTECH devices */
@@ -67,7 +68,11 @@ static struct usb_device_id id_table[] =
 	{ USB_DEVICE_AND_INTERFACE_INFO(LG_VENDOR_ID, LG_PRODUCT_VX4400_6000, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SANYO_VENDOR_ID, SANYO_PRODUCT_KATANA_LX, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_U520, 0xff, 0x00, 0x00) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML190_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML190_VZW, 0xff, 0xfe, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xfd, 0xff) },  /* NMEA */
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xfe, 0xff) },  /* WMC */
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xff, 0xff) },  /* DIAG */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


