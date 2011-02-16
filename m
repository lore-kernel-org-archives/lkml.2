Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1BPBXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:23:01 -0500
Received: from kroah.org ([198.145.64.141]:45172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743Ab1BPAre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:00 2011
Message-Id: <20110216002100.492728134@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>
Subject: [patch 014/176] USB: qcaux: add Pantech UML290 device ID
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit a58861fbde2a350df4d27fc62fb42905669b37ce upstream.

Another CDC-ACM + vendor specific interface layout for the QCDM port.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcaux.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -36,6 +36,7 @@
 #define UTSTARCOM_PRODUCT_UM175_V1		0x3712
 #define UTSTARCOM_PRODUCT_UM175_V2		0x3714
 #define UTSTARCOM_PRODUCT_UM175_ALLTEL		0x3715
+#define PANTECH_PRODUCT_UML290_VZW		0x3718
 
 /* CMOTECH devices */
 #define CMOTECH_VENDOR_ID			0x16d8
@@ -66,6 +67,7 @@ static struct usb_device_id id_table[] =
 	{ USB_DEVICE_AND_INTERFACE_INFO(LG_VENDOR_ID, LG_PRODUCT_VX4400_6000, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SANYO_VENDOR_ID, SANYO_PRODUCT_KATANA_LX, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_U520, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xff, 0xff) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


