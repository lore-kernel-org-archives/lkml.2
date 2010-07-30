Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab0G3SQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:16:47 -0400
Received: from kroah.org ([198.145.64.141]:58915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760055Ab0G3R4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.242705920@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dennis Jansen <Dennis.Jansen@web.de>
Subject: [135/205] USB: option: Add support for AMOI Skypephone S2
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -227,6 +227,7 @@ static int  option_resume(struct usb_ser
 #define AMOI_PRODUCT_H01			0x0800
 #define AMOI_PRODUCT_H01A			0x7002
 #define AMOI_PRODUCT_H02			0x0802
+#define AMOI_PRODUCT_SKYPEPHONE_S2		0x0407
 
 #define DELL_VENDOR_ID				0x413C
 
@@ -538,6 +539,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H02) },
+	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_SKYPEPHONE_S2) },
 
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_MINICARD) },		/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite EV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5500_MINICARD) },		/* Dell Wireless 5500 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */


