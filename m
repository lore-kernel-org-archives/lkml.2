Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab2HJOZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:25:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50367 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2HJOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:25:22 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] USB: ftdi_sio: Add VID/PID for Kondo Serial USB
Date: Fri, 10 Aug 2012 17:25:10 +0300
Message-Id: <1344608710-11602-1-git-send-email-ozancag@gmail.com>
X-Mailer: git-send-email 1.7.11.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds VID/PID for Kondo Kagaku Co. Ltd. Serial USB Adapter
interface:
http://www.kondo-robot.com/EN/wp/?cat=28

Tested by controlling an RCB3 board using libRCB3.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4b8b41a..24e3e19 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -811,6 +811,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
 	{ USB_DEVICE(PI_VID, PI_E861_PID) },
+	{ USB_DEVICE(KONDO_VID, KONDO_USB_SERIAL_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5661c7e..5dd96ca 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -795,6 +795,13 @@
 #define PI_E861_PID         0x1008  /* E-861 piezo controller USB connection */
 
 /*
+ * Kondo Kagaku Co.Ltd.
+ * http://www.kondo-robot.com/EN
+ */
+#define KONDO_VID 		0x165c
+#define KONDO_USB_SERIAL_PID	0x0002
+
+/*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
  * http://winglucofacts.com/cables/
  */
-- 
1.7.11.2

