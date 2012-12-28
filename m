Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2L1Tb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:31:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab2L1TTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:20 -0500
Message-Id: <20121228190342.521911603@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin McKinney <klmckinney1@gmail.com>,
        Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 059/173] Staging: bcm: Add two products and remove an existing product.
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

commit 4f29ef050848245f7c180b95ccf67dfcd76b1fd8 upstream.

This patch adds two new products and modifies
the device id table to include them. In addition,
product of 0xbccd - BCM_USB_PRODUCT_ID_SM250 is
removed because Beceem, ZTE, Sprint use this id
for block devices.

Reported-by: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/bcm/InterfaceInit.c |    3 ++-
 drivers/staging/bcm/InterfaceInit.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -4,11 +4,12 @@ static struct usb_device_id InterfaceUsb
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -8,11 +8,11 @@
 #define BCM_USB_PRODUCT_ID_T3 	0x0300
 #define BCM_USB_PRODUCT_ID_T3B 	0x0210
 #define BCM_USB_PRODUCT_ID_T3L 	0x0220
-#define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
 #define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
 #define BCM_USB_PRODUCT_ID_ZTE_226 0x172
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
 
 #define BCM_USB_MINOR_BASE 		192


