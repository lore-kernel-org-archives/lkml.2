Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3AIWEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:04:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:40946 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab3AIUgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jay Purohit <jspurohit@velocitylimitless.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/47] usb/ipheth: Add iPhone 5 support
Date: Wed,  9 Jan 2013 12:35:02 -0800
Message-Id: <20130109201730.346728221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jay Purohit <jspurohit@velocitylimitless.com>

[ Upstream commit af1b85e49089f945deb46258b0fc4bc9910afb22 ]

I noticed that the iPhone ethernet driver did not support
iPhone 5. I quickly added support to it in my kernel, here's
a patch.

Signed-off-by: Jay Purohit <jspurohit@velocitylimitless.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -62,6 +62,7 @@
 #define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
+#define USB_PRODUCT_IPHONE_5	0x12a8
 
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -113,6 +114,10 @@ static struct usb_device_id ipheth_table
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


