Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2HTEBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:01:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2HTEBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: =?UTF-8?q?=5B=2036/46=5D=20USB=3A=20ftdi=5Fsio=3A=20Add=20VID/PID=20for=20Kondo=20Serial=20USB?=
Date: Sun, 19 Aug 2012 20:59:12 -0700
Message-Id: <20120820035837.272463153@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ozan Çağlayan <ozancag@gmail.com>

commit 7724a1edbe463b06d4e7831a41149ba095b16c53 upstream.

This adds VID/PID for Kondo Kagaku Co. Ltd. Serial USB Adapter
interface:
http://www.kondo-robot.com/EN/wp/?cat=28

Tested by controlling an RCB3 board using libRCB3.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -811,6 +811,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
 	{ USB_DEVICE(PI_VID, PI_E861_PID) },
+	{ USB_DEVICE(KONDO_VID, KONDO_USB_SERIAL_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
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


