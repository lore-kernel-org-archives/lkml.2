Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2FYHDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:03:24 -0400
Received: from server.irh.it ([109.74.199.9]:36186 "EHLO server.irh.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2FYHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 03:03:22 -0400
From: Davide Gerhard <rainbow@irh.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davide Gerhard <rainbow@irh.it>
Subject: [PATCH 1/1] ipheth: add support for iPad
Date: Mon, 25 Jun 2012 09:04:47 +0200
Message-Id: <1340607887-28648-1-git-send-email-rainbow@irh.it>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the iPad to the ipheth driver.
(product id = 0x129a)

Signed-off-by: Davide Gerhard <rainbow@irh.it>
---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 964031e..9c98449 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -59,6 +59,7 @@
 #define USB_PRODUCT_IPHONE_3G   0x1292
 #define USB_PRODUCT_IPHONE_3GS  0x1294
 #define USB_PRODUCT_IPHONE_4	0x1297
+#define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
 
@@ -101,6 +102,10 @@ static struct usb_device_id ipheth_table[] = {
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPAD,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4_VZW,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
-- 
1.7.10.2

