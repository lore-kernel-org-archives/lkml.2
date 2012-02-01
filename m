Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2BAVu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:50:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37494 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093Ab2BAVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:28 -0500
X-Sasl-enc: 4aUPAFSvhgi5HE3PE/Sa07fug/0lk67chYbcukut0bV7 1328130508
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.680121087@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kentaro Matsuyama <kentaro.matsuyama@gmail.com>
Subject: [25/65] USB: option: Add LG docomo L-02C
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kentaro Matsuyama <kentaro.matsuyama@gmail.com>

commit e423d7401fd0717cb56a6cf51dd8341cc3e800d2 upstream.

Add vendor and product ID for USB 3G/LTE modem of docomo L-02C

Signed-off-by: Kentaro Matsuyama <kentaro.matsuyama@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -480,6 +480,10 @@ static void option_instat_callback(struc
 #define ZD_VENDOR_ID				0x0685
 #define ZD_PRODUCT_7000				0x7000
 
+/* LG products */
+#define LG_VENDOR_ID				0x1004
+#define LG_PRODUCT_L02C				0x618f
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1183,6 +1187,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


