Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1KJFCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:02:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935062Ab1KJD3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.682744589@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kavan Smith <kavansmith82@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [170/262] ipheth: iPhone 4 Verizon CDMA USB Product ID add
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kavan Smith <kavansmith82@gmail.com>

commit 02009afc223aae43b8e18918fc816e4520791537 upstream.

Add USB product ID for iPhone 4 CDMA Verizon
Tested on at least 2 devices

Signed-off-by: Kavan Smith <kavansmith82@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -59,6 +59,7 @@
 #define USB_PRODUCT_IPHONE_3G   0x1292
 #define USB_PRODUCT_IPHONE_3GS  0x1294
 #define USB_PRODUCT_IPHONE_4	0x1297
+#define USB_PRODUCT_IPHONE_4_VZW 0x129c
 
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -98,6 +99,10 @@ static struct usb_device_id ipheth_table
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4_VZW,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);


