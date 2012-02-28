Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512Ab2B1BT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58867 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409Ab2B1BTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.226.170 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.025960508@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Till Kamppeter <till.kamppeter@gmail.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/72] ipheth: Add iPhone 4S
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

commit 72ba009b8a159e995e40d3b4e5d7d265acead983 upstream.

BugLink: http://bugs.launchpad.net/bugs/900802

Signed-off-by: Till Kamppeter <till.kamppeter@gmail.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -60,6 +60,7 @@
 #define USB_PRODUCT_IPHONE_3GS  0x1294
 #define USB_PRODUCT_IPHONE_4	0x1297
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
+#define USB_PRODUCT_IPHONE_4S	0x12a0
 
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -103,6 +104,10 @@ static struct usb_device_id ipheth_table
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4_VZW,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4S,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);


