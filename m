Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0IRTdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:33:09 -0400
Received: from kroah.org ([198.145.64.141]:43368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0IRTPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:08 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191300.979583535@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luke Lowrey <luke@chamsys.co.uk>
Subject: [043/129] USB: ftdi_sio: Added custom PIDs for ChamSys products
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -753,6 +753,14 @@ static struct usb_device_id id_table_com
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


