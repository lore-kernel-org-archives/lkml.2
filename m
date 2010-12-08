Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0LHA6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:58:02 -0500
Received: from kroah.org ([198.145.64.141]:58487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab0LHArm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:42 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:32 2010
Message-Id: <20101208004432.189434182@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacques Viviers <jacques.viviers@gmail.com>
Subject: [079/127] USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jacques Viviers <jacques.viviers@gmail.com>

commit 6fdbad8021151a9e93af8159a6232c8f26415c09 upstream.

Add the PID for the Vardaan Enterprises VEUSB422R3 USB to RS422/485
converter. It uses the same chip as the FTDI_8U232AM_PID 0x6001.

This should also work with the stable branches for:
2.6.31, 2.6.32, 2.6.33, 2.6.34, 2.6.35, 2.6.36

Signed-off-by: Jacques Viviers <jacques.viviers@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -206,6 +206,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
+	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -114,6 +114,9 @@
 /* Lenz LI-USB Computer Interface. */
 #define FTDI_LENZ_LIUSB_PID	0xD780
 
+/* Vardaan Enterprises Serial Interface VEUSB422R3 */
+#define FTDI_VARDAAN_PID	0xF070
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */


