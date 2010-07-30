Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab0G3Rri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:47:38 -0400
Received: from kroah.org ([198.145.64.141]:36051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab0G3Rfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173111.935065436@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dennis Jansen <Dennis.Jansen@web.de>
Subject: [102/140] USB: option: Add support for AMOI Skypephone S2
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dennis Jansen <d.g.jansen@googlemail.com>

commit 7595931c986f50b1e197ce7b881563e36a7d041e upstream.

usbserial: Add AMOI Skypephone S2 support.

This patch adds support for the AMOI Skypephone S2 to the usbserial module.

Tested-by: Dennis Jansen <Dennis.Jansen@web.de>
Signed-off-by: Dennis Jansen <Dennis.Jansen@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -226,6 +226,7 @@ static int  option_resume(struct usb_ser
 #define AMOI_PRODUCT_H01			0x0800
 #define AMOI_PRODUCT_H01A			0x7002
 #define AMOI_PRODUCT_H02			0x0802
+#define AMOI_PRODUCT_SKYPEPHONE_S2		0x0407
 
 #define DELL_VENDOR_ID				0x413C
 
@@ -504,6 +505,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H02) },
+	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_SKYPEPHONE_S2) },
 
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_MINICARD) },		/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite EV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5500_MINICARD) },		/* Dell Wireless 5500 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */


