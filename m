Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1FPHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43018 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756813Ab1FPHKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:43 -0400
X-Sasl-enc: 4r0sFVHri/KaJfn7QTwKnHFZ5V559i3wQruMgHEOa4bl 1308208242
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:06 2011
Message-Id: <20110616002906.799427854@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Benedek=20L=C3=A1szl=C3=B3?= <benedekl@gmail.com>
Subject: [30/85] USB: serial: ftdi_sio: adding support for TavIR STK500
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Benedek=20L=C3=A1szl=C3=B3?= <benedekl@gmail.com>

commit 37909fe588c9e09ab57cd267e98678a17ceda64a upstream.

Adding support for the TavIR STK500 (id 0403:FA33)
Atmel AVR programmer device based on FTDI FT232RL.

Signed-off-by: Benedek László <benedekl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -566,6 +566,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_APP70_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	/*
 	 * ELV devices:
 	 */
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -471,6 +471,11 @@
 /* www.canusb.com Lawicel CANUSB device (FTDI_VID) */
 #define FTDI_CANUSB_PID 0xFFA8 /* Product Id */
 
+/*
+ * TavIR AVR product ids (FTDI_VID)
+ */
+#define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
+
 
 
 /********************************/


