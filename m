Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0C3Xmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:42:51 -0400
Received: from kroah.org ([198.145.64.141]:46200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591Ab0C3XUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:24 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:07 2010
Message-Id: <20100330224807.272219280@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Sangorrin <daniel.sangorrin@gmail.com>,
       Andreas Mohr <andi@lisas.de>, Radek Liboska <liboska@uochb.cas.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [072/156] USB: serial: ftdi: add CONTEC vendor and product id
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Sangorrin <daniel.sangorrin@gmail.com>

commit dee5658b482e9e2ac7d6205dc876fc11d4008138 upstream.

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds identifiers for
CONTEC USB serial converter.  I tested it with the device COM-1(USB)H

[akpm@linux-foundation.org: keep the VIDs sorted a bit]
Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Radek Liboska <liboska@uochb.cas.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -658,6 +658,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(EVOLUTION_VID, EVOLUTION_ER1_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_HYBRID_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_RCM4_PID) },
+	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ARTEMIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16C_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -501,6 +501,13 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
 
 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */


