Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962Ab2C3WDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:03:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44933 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935879Ab2C3VQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:51 -0400
Message-Id: <20120330194825.861527815@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Meng Zhang <meng.zhang@mediatek.com>,
        Matthias Urlichs <matthias@urlichs.de>
Subject: [ 001/175] USB: option: Add MediaTek MT6276M modem&app interfaces
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meng Zhang <meng.zhang@mediatek.com>

commit 0d8520a1d7f43328bc7085d4244d93c595064157 upstream.

Add MEDIATEK products to Option driver

Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
Signed-off-by: Matthias Urlichs <matthias@urlichs.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -484,6 +484,9 @@ static void option_instat_callback(struc
 #define LG_VENDOR_ID				0x1004
 #define LG_PRODUCT_L02C				0x618f
 
+/* MediaTek products */
+#define MEDIATEK_VENDOR_ID			0x0e8d
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1198,6 +1201,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


