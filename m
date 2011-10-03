Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1JCJDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:03:53 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18409 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab1JCJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:03:46 -0400
From: <oskar.andero@sonyericsson.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hakan Kvist <hakan.kvist@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [PATCH] USB: ftdi_sio: add PID for Sony Ericsson Urban
Date: Mon, 3 Oct 2011 10:51:31 +0200
Message-ID: <1317631891-13648-1-git-send-email-oskar.andero@sonyericsson.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Kvist <hakan.kvist@sonyericsson.com>

Add PID 0xfc8a, 0xfc8b for device Sony Ericsson Urban

Signed-off-by: Hakan Kvist <hakan.kvist@sonyericsson.com>
Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5fc13e7..79fcac3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -207,6 +207,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_640_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_642_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DSS20_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_0_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_1_PID) },
 	{ USB_DEVICE(FTDI_NF_RIC_VID, FTDI_NF_RIC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VNHCPCUSB_D_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_0_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index bf5227a..9617f91 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -420,9 +420,11 @@
 #define PROTEGO_SPECIAL_4	0xFC73	/* special/unknown device */
 
 /*
- * DSS-20 Sync Station for Sony Ericsson P800
+ * Sony Ericsson product ids
  */
-#define FTDI_DSS20_PID          0xFC82
+#define FTDI_DSS20_PID          0xFC82 /* DSS-20 Sync Station for Sony Ericsson P800 */
+#define FTDI_URBAN_0_PID        0xFC8A /* Sony Ericsson Urban, uart #0 */
+#define FTDI_URBAN_1_PID        0xFC8B /* Sony Ericsson Urban, uart #1 */
 
 /* www.irtrans.de device */
 #define FTDI_IRTRANS_PID 0xFC60 /* Product Id */
-- 
1.7.3.4

