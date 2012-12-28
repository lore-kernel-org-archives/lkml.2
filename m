Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2L1Tx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:53:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484Ab2L1TRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:22 -0500
Message-Id: <20121228190401.014871610@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jay Purohit <jspurohit@velocitylimitless.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 158/173] usb/ipheth: Add iPhone 5 support
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/ipheth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 00ed9c1..ac53952 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -62,6 +62,7 @@
 #define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
+#define USB_PRODUCT_IPHONE_5	0x12a8
 
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -113,6 +114,10 @@ static struct usb_device_id ipheth_table[] = {
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


