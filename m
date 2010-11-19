Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab0KSW27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:28:59 -0500
Received: from kroah.org ([198.145.64.141]:45093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab0KSV6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:39 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:41 2010
Message-Id: <20101119215641.480867134@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rich Mattes <richmattes@gmail.com>
Subject: [33/82] USB: ftdi_sio: Add PID for accesio products
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rich Mattes <richmattes@gmail.com>

commit 3126d8236ca6f68eb8292c6af22c2e59afbeef24 upstream.

Adds support for Accesio USB to Serial adapters, which are built around
FTDI FT232 UARTs.  Tested with the Accesio USB-COM-4SM.

Signed-off-by: Rich Mattes <richmattes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -751,6 +751,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
+	{ USB_DEVICE(FTDI_VID, ACCESIO_COM4SM_PID) },
 	{ USB_DEVICE(IONICS_VID, IONICS_PLUGCOMPUTER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_24_MASTER_WING_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1063,3 +1063,9 @@
  * Submitted by John G. Rogers
  */
 #define SEGWAY_RMP200_PID	0xe729
+
+
+/*
+ * Accesio USB Data Acquisition products (http://www.accesio.com/)
+ */
+#define ACCESIO_COM4SM_PID 	0xD578


