Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564Ab2C3XMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:12:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761478Ab2C3VDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:24 -0400
Message-Id: <20120330195723.269202262@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Micha=C5=82=20Wr=C3=B3bel?= <michal.wrobel@flytronic.pl>
Subject: [ 008/108] USB: ftdi_sio: new PID: Distortec JTAG-lock-pick
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Wróbel <michal.wrobel@flytronic.pl>

commit 47594d5528f28a4c025c2955c68104c75815637c upstream.

Signed-off-by: Michał Wróbel <michal.wrobel@flytronic.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -845,6 +845,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -97,6 +97,8 @@
 #define FTDI_TACTRIX_OPENPORT_13S_PID	0xCC49	/* OpenPort 1.3 Subaru */
 #define FTDI_TACTRIX_OPENPORT_13U_PID	0xCC4A	/* OpenPort 1.3 Universal */
 
+#define FTDI_DISTORTEC_JTAG_LOCK_PICK_PID	0xCFF8
+
 /* SCS HF Radio Modems PID's (http://www.scs-ptc.com) */
 /* the VID is the standard ftdi vid (FTDI_VID) */
 #define FTDI_SCS_DEVICE_0_PID 0xD010    /* SCS PTC-IIusb */


