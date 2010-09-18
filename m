Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0IRTdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:33:50 -0400
Received: from kroah.org ([198.145.64.141]:43357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab0IRTPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:07 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.812290596@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Detring <jason.detring@navico.com>
Subject: [041/129] USB: cp210x: Add B&G H3000 link cable ID
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Detring <jason.detring@navico.com>

commit 0bf7a81c5d447c21db434be35363c44c0a30f598 upstream.

This is the cable between an H3000 navigation unit and a multi-function display.
http://www.bandg.com/en/Products/H3000/Spares-and-Accessories/Cables/H3000-CPU-USB-Cable-Pack/

Signed-off-by: Jason Detring <jason.detring@navico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -88,6 +88,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */


