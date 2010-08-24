Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab0HXW4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:56:22 -0400
Received: from kroah.org ([198.145.64.141]:52345 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab0HXWyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:31 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:27 2010
Message-Id: <20100824222526.944595909@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:25:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jef Driesen <jefdriesen@telenet.be>
Subject: [52/59] USB: pl2303: New vendor and product id
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jef Driesen <jefdriesen@telenet.be>

commit f36ecd5de93e4c85a9e3d25100c6e233155b12e5 upstream.

Add support for the Zeagle N2iTiON3 dive computer interface. Since
Zeagle devices are actually manufactured by Seiko, this patch will
support other Seiko based models as well.

Signed-off-by: Jef Driesen <jefdriesen@telenet.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -95,6 +95,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
+	{ USB_DEVICE(ZEAGLE_VENDOR_ID, ZEAGLE_N2ITION3_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ }					/* Terminating entry */
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -127,6 +127,10 @@
 #define CRESSI_VENDOR_ID	0x04b8
 #define CRESSI_EDY_PRODUCT_ID	0x0521
 
+/* Zeagle dive computer interface */
+#define ZEAGLE_VENDOR_ID	0x04b8
+#define ZEAGLE_N2ITION3_PRODUCT_ID	0x0522
+
 /* Sony, USB data cable for CMD-Jxx mobile phones */
 #define SONY_VENDOR_ID		0x054c
 #define SONY_QN3USB_PRODUCT_ID	0x0437


