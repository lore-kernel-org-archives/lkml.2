Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046Ab2B2Odk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:33:40 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60541 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031010Ab2B2Odj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:33:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dnlplm@gmail.com designates 10.14.27.142 as permitted sender) smtp.mail=dnlplm@gmail.com; dkim=pass header.i=dnlplm@gmail.com
From: Daniele Palmas <dnlplm@gmail.com>
To: Matthias Urlichs <smurf@smurf.noris.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniele.palmas@telit.com, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] USB: option driver: adding support for Telit CC864-SINGLE, CC864-DUAL and DE910-DUAL modems
Date: Wed, 29 Feb 2012 15:32:05 +0100
Message-Id: <1330525925-8395-1-git-send-email-dnlplm@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PID for Telit CC864-SINGLE, CC864-DUAL and DE910-DUAL
modems

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index b54afce..3eeb477 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -307,6 +307,9 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
 #define TELIT_PRODUCT_UC864G			0x1004
+#define TELIT_PRODUCT_CC864_DUAL		0x1005
+#define TELIT_PRODUCT_CC864_SINGLE		0x1006
+#define TELIT_PRODUCT_DE910_DUAL		0x1010
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -768,6 +771,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf1_blacklist },
-- 
1.7.5.4

