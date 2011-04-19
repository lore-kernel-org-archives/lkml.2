Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1DSURn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:43 -0400
Received: from kroah.org ([198.145.64.141]:35681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab1DSURf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:48 2011
Message-Id: <20110419201048.837033074@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [53/70] USB: ftdi_sio: add ids for Hameg HO720 and HO730
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Friedrich <Paul.Friedrich@hameg.com>

commit c53c2fab40cf16e13af66f40bfd27200cda98d2f upstream.

usb serial: ftdi_sio: add two missing USB ID's for Hameg interfaces HO720
and HO730

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -788,6 +788,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_GENERIC_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -300,6 +300,8 @@
  * Hameg HO820 and HO870 interface (using VID 0x0403)
  */
 #define HAMEG_HO820_PID			0xed74
+#define HAMEG_HO730_PID			0xed73
+#define HAMEG_HO720_PID			0xed72
 #define HAMEG_HO870_PID			0xed71
 
 /*


