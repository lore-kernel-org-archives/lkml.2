Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1FPHen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:34:43 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46104 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab1FPHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:11 -0400
X-Sasl-enc: Qxjs58ovdd1MyUtCXSjRgqlJEkpoNPMIJw64fBB0XRaJ 1308207670
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.579789111@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Sledz <sledz@dresearch-fe.de>
Subject: [57/89] USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steffen Sledz <sledz@dresearch-fe.de>

commit a26d31cef06f43a76327c21235e75450869df2b8 upstream.

E.g. newer CAN 2.0 A/B <=> USB 2.0 converters report idProduct=f3c2.

Signed-off-by: Steffen Sledz <sledz@dresearch-fe.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -647,6 +647,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_3_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_0_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_1_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -351,6 +351,7 @@
  */
 #define FTDI_4N_GALAXY_DE_1_PID	0xF3C0
 #define FTDI_4N_GALAXY_DE_2_PID	0xF3C1
+#define FTDI_4N_GALAXY_DE_3_PID	0xF3C2
 
 /*
  * Linx Technologies product ids


