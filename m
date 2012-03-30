Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667Ab2C3V4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:56:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57057 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965670Ab2C3VSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:40 -0400
Message-Id: <20120330194831.824352761@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Scott Dial <scott.dial@scientiallc.com>
Subject: [ 039/175] usb-serial: Add support for the Sealevel SeaLINK+8 2038-ROHS device
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Dial <scott.dial@scientiallc.com>

commit 6d161b99f875269ad4ffa44375e1e54bca6fd02e upstream.

This patch adds new device IDs to the ftdi_sio module to support
the new Sealevel SeaLINK+8 2038-ROHS device.

Signed-off-by: Scott Dial <scott.dial@scientiallc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    4 ++++
 drivers/usb/serial/ftdi_sio_ids.h |    4 ++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -537,6 +537,10 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_6_PID) },
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_7_PID) },
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_8_PID) },
+	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803R_1_PID) },
+	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803R_2_PID) },
+	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803R_3_PID) },
+	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803R_4_PID) },
 	{ USB_DEVICE(IDTECH_VID, IDTECH_IDT1221U_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_US101_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_DK201_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -689,6 +689,10 @@
 #define SEALEVEL_2803_6_PID	0X2863	/* SeaLINK+8 (2803) Port 6 */
 #define SEALEVEL_2803_7_PID	0X2873	/* SeaLINK+8 (2803) Port 7 */
 #define SEALEVEL_2803_8_PID	0X2883	/* SeaLINK+8 (2803) Port 8 */
+#define SEALEVEL_2803R_1_PID	0Xa02a	/* SeaLINK+8 (2803-ROHS) Port 1+2 */
+#define SEALEVEL_2803R_2_PID	0Xa02b	/* SeaLINK+8 (2803-ROHS) Port 3+4 */
+#define SEALEVEL_2803R_3_PID	0Xa02c	/* SeaLINK+8 (2803-ROHS) Port 5+6 */
+#define SEALEVEL_2803R_4_PID	0Xa02d	/* SeaLINK+8 (2803-ROHS) Port 7+8 */
 
 /*
  * JETI SPECTROMETER SPECBOS 1201


