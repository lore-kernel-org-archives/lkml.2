Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab1DZV0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:26:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:60554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab1DZVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327570"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jhovold@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [68/106] USB: ftdi_sio: add PID for OCT DK201 docking station
Message-Id: <20110426211349.5BC183E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit 11a31d84129dc3133417d626643d714c9df5317e upstream.

Add PID 0x0103 for serial port of the OCT DK201 docking station.

Reported-by: Jan Hoogenraad <jan@hoogenraad.net>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
@@ -526,6 +526,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_8_PID) },
 	{ USB_DEVICE(IDTECH_VID, IDTECH_IDT1221U_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_US101_PID) },
+	{ USB_DEVICE(OCT_VID, OCT_DK201_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_HE_TIRA1_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_HE_TIRA1_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_USB_UIRT_PID),
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -572,6 +572,7 @@
 /* Note: OCT US101 is also rebadged as Dick Smith Electronics (NZ) XH6381 */
 /* Also rebadged as Dick Smith Electronics (Aus) XH6451 */
 /* Also rebadged as SIIG Inc. model US2308 hardware version 1 */
+#define OCT_DK201_PID		0x0103	/* OCT DK201 USB docking station */
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
