Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0LMAAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:00:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0LLXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:47 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jacques.viviers@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [162/223] USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added
Message-Id: <20101212234746.32BFEB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jacques Viviers <jacques.viviers@gmail.com>

commit 6fdbad8021151a9e93af8159a6232c8f26415c09 upstream.

Add the PID for the Vardaan Enterprises VEUSB422R3 USB to RS422/485
converter. It uses the same chip as the FTDI_8U232AM_PID 0x6001.

This should also work with the stable branches for:
2.6.31, 2.6.32, 2.6.33, 2.6.34, 2.6.35, 2.6.36

Signed-off-by: Jacques Viviers <jacques.viviers@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

Index: linux/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio.c
+++ linux/drivers/usb/serial/ftdi_sio.c
@@ -201,6 +201,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
+	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
Index: linux/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux/drivers/usb/serial/ftdi_sio_ids.h
@@ -114,6 +114,9 @@
 /* Lenz LI-USB Computer Interface. */
 #define FTDI_LENZ_LIUSB_PID	0xD780
 
+/* Vardaan Enterprises Serial Interface VEUSB422R3 */
+#define FTDI_VARDAAN_PID	0xF070
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
