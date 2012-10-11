Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2JKTzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:55:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43425 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2JKTzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:55:43 -0400
MIME-Version: 1.0
X-Originating-IP: [24.153.172.130]
Date: Thu, 11 Oct 2012 14:55:42 -0500
Message-ID: <CADx9NEeyPUNrOiWHn97eOTp5skBqa7D9t8m_90QDAgs+kKtybg@mail.gmail.com>
Subject: [PATCH] iPhone 5 support for ipheth.
From: Jay Purohit <jspurohit@velocitylimitless.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the iPhone ethernet driver did not support
iPhone 5. I quickly added support to it in my kernel, here's
a patch.

--- linux-3.6.1/drivers/net/usb/ipheth.c	2012-10-07 10:41:28.000000000 -0500
+++ new/linux-3.6.1/drivers/net/usb/ipheth.c	2012-10-11 11:38:17.242000596 -0500
@@ -62,6 +62,8 @@
 #define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
+#define USB_PRODUCT_IPHONE_5	0x12a8
+

 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -113,6 +115,10 @@
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4S,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_5,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
