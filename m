Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2IIXig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:38:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559Ab2IIXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:50 -0400
Message-Id: <20120909224152.716506502@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 13/95] USB: ftdi_sio: Add VID/PID for Kondo Serial USB
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ozan Çağflayan <ozancag@gmail.com>

commit 7724a1edbe463b06d4e7831a41149ba095b16c53 upstream.

This adds VID/PID for Kondo Kagaku Co. Ltd. Serial USB Adapter
interface:
http://www.kondo-robot.com/EN/wp/?cat=28

Tested by controlling an RCB3 board using libRCB3.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bc912e5..5620db6 100644
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


