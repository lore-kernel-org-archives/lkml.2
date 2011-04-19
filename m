Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1DSVEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:04:30 -0400
Received: from kroah.org ([198.145.64.141]:39406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab1DSVE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:23 2011
Message-Id: <20110419210323.884112249@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Simon <simon@swine.de>
Subject: [15/26] USB: ftdi_sio: Added IDs for CTI USB Serial Devices
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1093,3 +1093,12 @@
 #define XVERVE_SIGNALYZER_SH2_PID	0xBCA2
 #define XVERVE_SIGNALYZER_SH4_PID	0xBCA4
 
+/*
+ * CTI GmbH RS485 Converter http://www.cti-lean.com/
+ */
+/* USB-485-Mini*/
+#define FTDI_CTI_MINI_PID	0xF608
+/* USB-Nano-485*/
+#define FTDI_CTI_NANO_PID	0xF60B
+
+


