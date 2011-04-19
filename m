Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1DSUrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:47:22 -0400
Received: from kroah.org ([198.145.64.141]:58970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1DSUmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:18 2011
Message-Id: <20110419204118.289404460@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Simon <simon@swine.de>
Subject: [15/28] USB: ftdi_sio: Added IDs for CTI USB Serial Devices
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Simon <simon@swine.de>

commit 5a9443f08c83c294c5c806a689c1184b27cb26b3 upstream.

I added new ProdutIds for two devices from CTI GmbH Leipzig.

Signed-off-by: Christian Simon <simon@swine.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -155,6 +155,8 @@ static struct ftdi_sio_quirk ftdi_stmcli
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1147,3 +1147,12 @@
 #define QIHARDWARE_VID			0x20B7
 #define MILKYMISTONE_JTAGSERIAL_PID	0x0713
 
+/*
+ * CTI GmbH RS485 Converter http://www.cti-lean.com/
+ */
+/* USB-485-Mini*/
+#define FTDI_CTI_MINI_PID	0xF608
+/* USB-Nano-485*/
+#define FTDI_CTI_NANO_PID	0xF60B
+
+


