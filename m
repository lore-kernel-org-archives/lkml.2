Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab1C3WKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:10:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:54022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165Ab1C3VGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235967"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: michael.h.williamson@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [29/275] USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph
Message-Id: <20110330210424.392FB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Williamson <michael.h.williamson@gmail.com>

commit 28fe2eb0162a1d23370dd99ff7d0e35632b1ee91 upstream.

Add the USB Vendor ID and Product ID for a Acton Research Corp.
spectrograph device with a FTDI chip for serial I/O.

Signed-off-by: Michael H Williamson <michael.h.williamson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c	2011-03-29 23:02:58.765331762 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c	2011-03-29 23:02:58.803330791 -0700
@@ -620,6 +620,7 @@
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 23:02:58.765331762 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 23:02:58.804330765 -0700
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
