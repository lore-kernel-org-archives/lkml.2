Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab1HFAQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:16:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1HFAMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:12 2011
Message-Id: <20110806000412.550730667@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Manuel Jander <manuel.jander@gmail.com>
Subject: [10/50] USB: pl2303: add AdLink ND-6530 USB IDs
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Manuel Jander <manuel.jander@gmail.com>

commit 9a61d72602771906e11a5944e8571f8006387b39 upstream.

I read a rumor that the AdLink ND6530 USB RS232, RS422 and RS485
isolated adapter is actually a PL2303 based usb serial adapter. I
tried it out, and as far as I can tell it works.

Signed-off-by: Manuel Jander <manuel.jander@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -99,6 +99,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
+	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -136,3 +136,7 @@
 /* Sanwa KB-USB2 multimeter cable (ID: 11ad:0001) */
 #define SANWA_VENDOR_ID		0x11ad
 #define SANWA_PRODUCT_ID	0x0001
+
+/* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
+#define ADLINK_VENDOR_ID        0x0b63
+#define ADLINK_ND6530_PRODUCT_ID       0x6530


