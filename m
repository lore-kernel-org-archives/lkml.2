Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162501Ab1FAJFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:05:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:43969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162014Ab1FAIQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:28 2011
Message-Id: <20110601080426.868697520@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:52 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Galczynski <marcin@galczynski.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [116/146] USB: option: add support for Huawei E353 device
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Marcin=20Ga=C5=82czy=C5=84ski?= <marcin@galczynski.pl>

commit 610ba42f29c3dfa46a05ff8c2cadc29f544ff76d upstream.

I am sharing patch to the devices/usb/serial/option.c. This allows
operation of Huawei E353 broadband modem using the “option” driver. The
patch simply adds new constant with proper product ID and an entry to
usb_device_id. I worked on the 2.6.38.6 sources. Tested on Dell inspiron
1764 (i3 core cpu) and brand new Huawei E353 modem, Fedora 15 beta.

Looking at the type of change, i doubt it has potential to introduce
problems in other parts of kernel or the driver itself.

Signed-off-by: Marcin Galczynski <marcin@galczynski.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -149,6 +149,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_ETS1220			0x1803
+#define HUAWEI_PRODUCT_E353			0x1506
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -532,6 +533,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V740) },


