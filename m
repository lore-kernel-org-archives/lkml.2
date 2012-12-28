Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2L1Tbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:31:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358Ab2L1TTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:21 -0500
Message-Id: <20121228190342.293540028@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin McKinney <klmckinney1@gmail.com>,
        Rinat Camalov <richman1000000d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 058/173] Staging: bcm: Create and initialize new device id in InterfaceInit
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin McKinney <klmckinney1@gmail.com>

commit e66fc1fba248738d32f3b64508f9ef1176d9e767 upstream.

This patch create and initalizes a new device
id of 0x172 as reported by Rinat Camalov
<richman1000000d@gmail.com>. In addition, a
comment is added to the potential invalid
existing device id.

Reported-by: Rinat Camalov <richman1000000d@gmail.com>
Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/bcm/InterfaceInit.c |    1 +
 drivers/staging/bcm/InterfaceInit.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -8,6 +8,7 @@ static struct usb_device_id InterfaceUsb
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -11,7 +11,8 @@
 #define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
-#define BCM_USB_PRODUCT_ID_226  0x0132
+#define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
+#define BCM_USB_PRODUCT_ID_ZTE_226 0x172
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
 
 #define BCM_USB_MINOR_BASE 		192


