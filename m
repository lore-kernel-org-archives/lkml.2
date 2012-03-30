Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478Ab2C3VJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:09:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935444Ab2C3VJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:05 -0400
Message-Id: <20120330194833.628820786@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniele Palmas <dnlplm@gmail.com>
Subject: [ 002/149] USB: option driver: adding support for Telit CC864-SINGLE, CC864-DUAL and DE910-DUAL modems
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 7204cf584836c24b4b06e4ad4a8e6bb8ea84908e upstream.

Adding PID for Telit CC864-SINGLE, CC864-DUAL and DE910-DUAL
modems

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -307,6 +307,9 @@ static void option_instat_callback(struc
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
 #define TELIT_PRODUCT_UC864G			0x1004
+#define TELIT_PRODUCT_CC864_DUAL		0x1005
+#define TELIT_PRODUCT_CC864_SINGLE		0x1006
+#define TELIT_PRODUCT_DE910_DUAL		0x1010
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -771,6 +774,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf1_blacklist },


