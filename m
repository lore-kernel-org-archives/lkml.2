Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1BPARz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:17:55 -0500
Received: from kroah.org ([198.145.64.141]:38542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1BPARw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:17:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:25 2011
Message-Id: <20110216001425.161456197@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:10:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>
Subject: [001/272] Staging: Beceem: add USB id for BCSM250 Mobile WiMAX
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 85c0b1760a7c259679d188bef58866fc641deca5 upstream.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/bcm/InterfaceInit.c |    1 +
 drivers/staging/bcm/InterfaceInit.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -4,6 +4,7 @@ static struct usb_device_id InterfaceUsb
     { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
     	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
     {}
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -8,6 +8,7 @@
 #define BCM_USB_PRODUCT_ID_T3 	0x0300
 #define BCM_USB_PRODUCT_ID_T3B 	0x0210
 #define BCM_USB_PRODUCT_ID_T3L 	0x0220
+#define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
 #define BCM_USB_PRODUCT_ID_226  0x0132


