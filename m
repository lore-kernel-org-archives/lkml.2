Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1LGQTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:19:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab1LGQTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:19:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:26 2011
Message-Id: <20111207160826.782896219@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:11 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        =?UTF-8?q?Marcin=20Ko=C5=9Bcielnicki?= <koriakin@0x04.net>
Subject: [51/80] usb: ftdi_sio: add PID for Propox ISPcable III
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Kościelnicki <koriakin@0x04.net>

commit 307369b0ca06b27b511b61714e335ddfccf19c4f upstream.

Signed-off-by: Marcin Kościelnicki <koriakin@0x04.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -735,6 +735,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELSTER_UNICOM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_JTAGCABLEII_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_ISPCABLEIII_PID) },
 	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_H_PID),
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -112,6 +112,7 @@
 
 /* Propox devices */
 #define FTDI_PROPOX_JTAGCABLEII_PID	0xD738
+#define FTDI_PROPOX_ISPCABLEIII_PID	0xD739
 
 /* Lenz LI-USB Computer Interface. */
 #define FTDI_LENZ_LIUSB_PID	0xD780


