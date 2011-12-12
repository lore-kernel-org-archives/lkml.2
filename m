Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1LLNSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:18:12 -0500
Received: from ni.piap.pl ([195.187.100.4]:37755 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1LLNSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:18:10 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 08:18:09 EST
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Oliver Neukum <oliver@neukum.name>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 14:10:23 +0100
MIME-Version: 1.0
Message-ID: <m3liqiylz4.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Add PCI IDs for Motorola H24 HSPA USB module.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20111212 #5986898, check: 20111212 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCI IDs for Motorola H24 HSPA USB module.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1458,6 +1458,16 @@ static const struct usb_device_id acm_ids[] = {
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

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
