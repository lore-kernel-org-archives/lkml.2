Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2BAVcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:32:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38935 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757434Ab2BAVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:03 -0500
X-Sasl-enc: CNu0iA97UgGdDfjnXHA+q63HR/qBi0yA0FSKLUapAYJK 1328131142
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:40 2012
Message-Id: <20120201205740.122901097@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>
Subject: [30/65] USB: ftdi_sio: Add more identifiers
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 2353f806c97020d4c7709f15eebb49b591f7306d upstream.

0x04d8, 0x000a: Hornby Elite

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -796,6 +796,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(HORNBY_VID, HORNBY_ELITE_PID) },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -532,6 +532,12 @@
 #define ADI_GNICEPLUS_PID	0xF001
 
 /*
+ * Hornby Elite
+ */
+#define HORNBY_VID		0x04D8
+#define HORNBY_ELITE_PID	0x000A
+
+/*
  * RATOC REX-USB60F
  */
 #define RATOC_VENDOR_ID		0x0584


