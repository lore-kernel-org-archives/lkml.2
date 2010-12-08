Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0LHA6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:58:23 -0500
Received: from kroah.org ([198.145.64.141]:58480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab0LHArl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:41 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:32 2010
Message-Id: <20101208004432.089180519@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Stuermer <ms@mallorn.de>
Subject: [078/127] USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Stuermer <ms@mallorn.de>

commit 28942bb6a9dd4e2ed793675e515cfb8297ed355b upstream.

Another variant of the RT Systems programming cable for ham radios.

Signed-off-by: Michael Stuermer <ms@mallorn.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -702,6 +702,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -728,6 +728,7 @@
  */
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
+#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.


