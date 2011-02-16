Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1BPBs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:48:26 -0500
Received: from kroah.org ([198.145.64.141]:38723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab1BPASt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:28 2011
Message-Id: <20110216001428.369096891@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael H Williamson <michael.h.williamson@gmail.com>
Subject: [033/272] USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Williamson <michael.h.williamson@gmail.com>

commit 28fe2eb0162a1d23370dd99ff7d0e35632b1ee91 upstream.

Add the USB Vendor ID and Product ID for a Acton Research Corp.
spectrograph device with a FTDI chip for serial I/O.

Signed-off-by: Michael H Williamson <michael.h.williamson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -620,6 +620,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -518,6 +518,12 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Acton Research Corp.
+ */
+#define ACTON_VID		0x0647	/* Vendor ID */
+#define ACTON_SPECTRAPRO_PID	0x0100
+
+/*
  * Contec products (http://www.contec.com)
  * Submitted by Daniel Sangorrin
  */


