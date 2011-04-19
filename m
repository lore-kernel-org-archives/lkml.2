Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1DSVE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:04:29 -0400
Received: from kroah.org ([198.145.64.141]:39410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab1DSVE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:24 2011
Message-Id: <20110419210323.999860138@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [16/26] USB: ftdi_sio: add PID for OCT DK201 docking station
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 11a31d84129dc3133417d626643d714c9df5317e upstream.

Add PID 0x0103 for serial port of the OCT DK201 docking station.

Reported-by: Jan Hoogenraad <jan@hoogenraad.net>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -527,6 +527,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_8_PID) },
 	{ USB_DEVICE(IDTECH_VID, IDTECH_IDT1221U_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_US101_PID) },
+	{ USB_DEVICE(OCT_VID, OCT_DK201_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_HE_TIRA1_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_HE_TIRA1_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_USB_UIRT_PID),
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -559,6 +559,7 @@
 /* Note: OCT US101 is also rebadged as Dick Smith Electronics (NZ) XH6381 */
 /* Also rebadged as Dick Smith Electronics (Aus) XH6451 */
 /* Also rebadged as SIIG Inc. model US2308 hardware version 1 */
+#define OCT_DK201_PID		0x0103	/* OCT DK201 USB docking station */
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*


