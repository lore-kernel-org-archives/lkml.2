Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab2AJXAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:00:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab2AJXAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:00:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:23 2012
Message-Id: <20120110215023.592259993@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, VU Tuan Duc <ducvt@viettel.com.vn>
Subject: [31/42] USB: option: add id for 3G dongle Model VT1000 of Viettel
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: VU Tuan Duc <DucVT@viettel.com.vn>

commit 5b061623355d8f69327a24838b0aa05e435ae5d5 upstream.

Add VendorID/ProductID for USB 3G dongle Model VT1000 of Viettel.

Signed-off-by: VU Tuan Duc <ducvt@viettel.com.vn>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -472,6 +472,10 @@ static void option_instat_callback(struc
 #define YUGA_PRODUCT_CLU528			0x260D
 #define YUGA_PRODUCT_CLU526			0x260F
 
+/* Viettel products */
+#define VIETTEL_VENDOR_ID			0x2262
+#define VIETTEL_PRODUCT_VT1000			0x0002
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1173,6 +1177,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU516) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU528) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


