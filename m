Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2FTSY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:24:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab2FTSYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:50 -0400
Message-Id: <20120620173040.869199341@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Evan McNabb <evan@mcnabbs.org>
Subject: [ 15/20] USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial
 adapter
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evan McNabb <evan@mcnabbs.org>

commit e00a54d772210d450e5c1a801534c3c8a448549f upstream.

Add support for RT Systems USB-RTS01 USB to Serial adapter:
http://www.rtsystemsinc.com/Photos/USBRTS01.html

Tested by controlling Icom IC-718 amateur radio transceiver via hamlib.

Signed-off-by: Evan McNabb <evan@mcnabbs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -735,6 +735,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -784,6 +784,7 @@
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
 #define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
+#define RTSYSTEMS_RTS01_PID		0x9e57	/* USB-RTS01 Radio Cable */
 
 
 /*


