Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0IBKbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:31:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0IBKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:31:31 -0400
From: Luke Lowrey <luke@chamsys.co.uk>
To: gregkh@suse.de
Cc: jhovold@gmail.com, andi@lisas.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luke Lowrey <luke@chamsys.co.uk>
Subject: [PATCH] USB: ftdi_sio: Added custom PIDs for ChamSys products
Date: Thu,  2 Sep 2010 11:39:49 +0100
Message-Id: <1283423989-5710-1-git-send-email-luke@chamsys.co.uk>
X-Mailer: git-send-email 1.5.6.5
X-Provags-ID: V02:K0:0dO4K8lVHBP8ruRX8EHEF4tR/Bzx0NqqUSJNOG6eX1v
 J0sF3ujFziR1EwuVz3PKJPOxBrunzoOOO7QS6vDiHHpLBA8NvZ
 lG4KvTsooKCYMs+Y/d2hXrOnYRVrNpYIHe8gRx3U6BHkTLuU00
 aQq+EZ2WRSce1/u6A/iRXcs4hyOm2lNv4fXbTwvP2adrKLn7TO
 nDPtaCWZV+gNFuMNBd/QfY9GGFyltRcnkco+TvQ+9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the 0xDAF8 to 0xDAFF PID range for ChamSys limited USB interface/wing products

Signed-off-by: Luke Lowrey <luke@chamsys.co.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    8 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h |   12 ++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c792c96..97cc87d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -753,6 +753,14 @@ static struct usb_device_id id_table_combined [] = {
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
index 2e95857..15a4583 100644
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
1.5.6.5

