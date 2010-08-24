Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0HXWyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:54:50 -0400
Received: from kroah.org ([198.145.64.141]:52365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab0HXWyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:37 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:27 2010
Message-Id: <20100824222527.375126696@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:25:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Michlmayr <tbm@cyrius.com>
Subject: [57/59] USB: ftdi_sio: Add ID for Ionics PlugComputer
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Michlmayr <tbm@cyrius.com>

commit 666cc076d284e32d11bfc5ea2fbfc50434cff051 upstream.

Add the ID for the Ionics PlugComputer (<http://ionicsplug.com/>).

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -756,6 +756,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
+	{ USB_DEVICE(IONICS_VID, IONICS_PLUGCOMPUTER_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -996,6 +996,12 @@
 #define ALTI2_N3_PID	0x6001	/* Neptune 3 */
 
 /*
+ * Ionics PlugComputer
+ */
+#define IONICS_VID			0x1c0c
+#define IONICS_PLUGCOMPUTER_PID		0x0102
+
+/*
  * Dresden Elektronic Sensor Terminal Board
  */
 #define DE_VID			0x1cf1 /* Vendor ID */


