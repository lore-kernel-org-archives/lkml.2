Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961Ab2LNXHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:07:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:41290 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422763Ab2LNXG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:06:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>,
        Kevin McKinney <klmckinney1@gmail.com>
Subject: [ 27/27] Staging: bcm: Add two products and remove an existing product.
Date: Fri, 14 Dec 2012 15:01:40 -0800
Message-Id: <20121214222256.895948215@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
 #define BCM_USB_PRODUCT_ID_T3	0x0300
 #define BCM_USB_PRODUCT_ID_T3B	0x0210
 #define BCM_USB_PRODUCT_ID_T3L	0x0220
-#define BCM_USB_PRODUCT_ID_SM250	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM	0x15E
 #define BCM_USB_PRODUCT_ID_1901	0xe017
 #define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
 #define BCM_USB_PRODUCT_ID_ZTE_226 0x172
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25	0x0007
 
 #define BCM_USB_MINOR_BASE	192


