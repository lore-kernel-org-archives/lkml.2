Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0KRAsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:48:41 -0500
Received: from rps9232.ovh.net ([94.23.201.187]:33955 "EHLO sirion.mallorn.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114Ab0KRAsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:48:39 -0500
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 19:48:39 EST
Date: Thu, 18 Nov 2010 00:45:43 +0100
From: Michael Stuermer <ms@mallorn.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20101117234543.GB23213@sirion.mallorn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ms@mallorn.de
Subject: [PATCH] USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on sirion.mallorn.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Stuermer <ms@mallorn.de>

Another variant of the RT Systems programming cable for ham radios.

Signed-off-by: Michael Stuermer <ms@mallorn.de>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 76f8b35..1c5892a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -696,6 +696,7 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 263f625..cee062f 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -721,6 +721,7 @@
  */
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
+#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
-- 
1.5.6.5

