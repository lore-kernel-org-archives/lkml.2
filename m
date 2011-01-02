Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1ABIGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:06:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:34535 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1ABHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:10 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Luke Lowrey <luke@chamsys.co.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 049/260] USB: ftdi_sio: Added custom PIDs for ChamSys products
Date: Sun,  2 Jan 2011 02:15:45 -0500
Message-Id: <1293952756-15010-50-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:59.0366 (UTC) FILETIME=[9AA15860:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luke Lowrey <luke@chamsys.co.uk>

commit 657373883417b2618023fd4135d251ba06a2c30a upstream.

Added the 0xDAF8 to 0xDAFF PID range for ChamSys limited USB interface/wing products

Signed-off-by: Luke Lowrey <luke@chamsys.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    8 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   12 ++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ce929e4..fd5c874 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -759,6 +759,14 @@ static struct usb_device_id id_table_combined [] = {
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
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 792f005..6eb1592 100644
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
-- 
1.7.3.3

