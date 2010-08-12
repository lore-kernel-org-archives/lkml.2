Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0HLAMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:12:52 -0400
Received: from kroah.org ([198.145.64.141]:47920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab0HLAIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:49 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.288439672@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Kazlou <p.i.kazlou@gmail.com>
Subject: [50/67] USB: option: Huawei ETS 1220 support added
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Kazlou <p.i.kazlou@gmail.com>

commit b972302b0a13aaddc9e90da2b4b52722e5d0e776 upstream.

The patch adds Huawei ETS 1220 product id into the list of supported
devices in 'option' usb serial driver.

Signed-off-by: Pavel Kazlou <p.i.kazlou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -146,6 +146,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_E143E			0x143E
 #define HUAWEI_PRODUCT_E143F			0x143F
 #define HUAWEI_PRODUCT_E14AC			0x14AC
+#define HUAWEI_PRODUCT_ETS1220			0x1803
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -482,6 +483,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */


