Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0IRTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:09 -0400
Received: from kroah.org ([198.145.64.141]:51193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab0IRTBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:23 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.789199885@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luke Lowrey <luke@chamsys.co.uk>
Subject: [023/123] USB: ftdi_sio: Added custom PIDs for ChamSys products
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-ftdi_sio-added-custom-pids-for-chamsys-products.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luke Lowrey <luke@chamsys.co.uk>

commit 657373883417b2618023fd4135d251ba06a2c30a upstream.

Added the 0xDAF8 to 0xDAFF PID range for ChamSys limited USB interface/wing products

Signed-off-by: Luke Lowrey <luke@chamsys.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    8 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   12 ++++++++++++
 2 files changed, 20 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -759,6 +759,14 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
 	{ USB_DEVICE(IONICS_VID, IONICS_PLUGCOMPUTER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_24_MASTER_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_PC_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_USB_DMX_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MIDI_TIMECODE_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MINI_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MAXI_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MEDIA_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_WING_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -135,6 +135,18 @@
 #define FTDI_NDI_AURORA_SCU_PID		0xDA74	/* NDI Aurora SCU */
 
 /*
+ * ChamSys Limited (www.chamsys.co.uk) USB wing/interface product IDs
+ */
+#define FTDI_CHAMSYS_24_MASTER_WING_PID        0xDAF8
+#define FTDI_CHAMSYS_PC_WING_PID       0xDAF9
+#define FTDI_CHAMSYS_USB_DMX_PID       0xDAFA
+#define FTDI_CHAMSYS_MIDI_TIMECODE_PID 0xDAFB
+#define FTDI_CHAMSYS_MINI_WING_PID     0xDAFC
+#define FTDI_CHAMSYS_MAXI_WING_PID     0xDAFD
+#define FTDI_CHAMSYS_MEDIA_WING_PID    0xDAFE
+#define FTDI_CHAMSYS_WING_PID  0xDAFF
+
+/*
  * Westrex International devices submitted by Cory Lee
  */
 #define FTDI_WESTREX_MODEL_777_PID	0xDC00	/* Model 777 */


