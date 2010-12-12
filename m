Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0LLXrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36515 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab0LLXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:46 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: ms@mallorn.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [161/223] USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable
Message-Id: <20101212234745.228C6B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Stuermer <ms@mallorn.de>

commit 28942bb6a9dd4e2ed793675e515cfb8297ed355b upstream.

Another variant of the RT Systems programming cable for ham radios.

Signed-off-by: Michael Stuermer <ms@mallorn.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

Index: linux/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio.c
+++ linux/drivers/usb/serial/ftdi_sio.c
@@ -696,6 +696,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
Index: linux/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux/drivers/usb/serial/ftdi_sio_ids.h
@@ -721,6 +721,7 @@
  */
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
+#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
