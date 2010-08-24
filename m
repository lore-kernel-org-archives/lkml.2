Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0HXXHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:07:18 -0400
Received: from kroah.org ([198.145.64.141]:32865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715Ab0HXXDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:43 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:10 2010
Message-Id: <20100824224510.312100900@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: [104/114] USB: option: add Celot CT-650
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Tokarev <mjt@tls.msk.ru>

commit 76078dc4fc389185fe467d33428f259ea9e69807 upstream.

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -368,6 +368,10 @@ static void option_instat_callback(struc
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 
+/* Celot products */
+#define CELOT_VENDOR_ID				0x211f
+#define CELOT_PRODUCT_CT680M			0x6801
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -891,10 +895,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_100F) },
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1011)},
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_1012)},
-
 	{ USB_DEVICE(CINTERION_VENDOR_ID, 0x0047) },
-
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
+	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


