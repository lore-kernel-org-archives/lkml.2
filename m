Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917Ab1LPUEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:04:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab1LPTuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:02 2011
Message-Id: <20111216194602.400838979@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Oliver Neukum <oneukum@suse.de>
Subject: [51/53] USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Hałasa <khalasa@piap.pl>

commit 6abff5dc4d5a2c90e597137ce8987e7fd439259b upstream.

Add USB IDs for Motorola H24 HSPA USB module.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1458,6 +1458,16 @@ static const struct usb_device_id acm_id
 	},
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
+	/* Motorola H24 HSPA module: */
+	{ USB_DEVICE(0x22b8, 0x2d91) }, /* modem                                */
+	{ USB_DEVICE(0x22b8, 0x2d92) }, /* modem           + diagnostics        */
+	{ USB_DEVICE(0x22b8, 0x2d93) }, /* modem + AT port                      */
+	{ USB_DEVICE(0x22b8, 0x2d95) }, /* modem + AT port + diagnostics        */
+	{ USB_DEVICE(0x22b8, 0x2d96) }, /* modem                         + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d97) }, /* modem           + diagnostics + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d99) }, /* modem + AT port               + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d9a) }, /* modem + AT port + diagnostics + NMEA */
+
 	{ USB_DEVICE(0x0572, 0x1329), /* Hummingbird huc56s (Conexant) */
 	.driver_info = NO_UNION_NORMAL, /* union descriptor misplaced on
 					   data interface instead of


