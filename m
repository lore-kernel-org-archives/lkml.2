Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2CMAz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:55:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47811 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab2CMAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Simon <simon@swine.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 069/196] USB: ftdi_sio: Added IDs for CTI USB Serial Devices
Date: Mon, 12 Mar 2012 20:19:42 -0400
Message-Id: <1331598109-31424-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Simon <simon@swine.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5a9443f08c83c294c5c806a689c1184b27cb26b3 upstream.

I added new ProdutIds for two devices from CTI GmbH Leipzig.

[PG: fix cosmetic whitespace warning coming from git am]

Signed-off-by: Christian Simon <simon@swine.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 05dcaa0..193a59b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -155,6 +155,8 @@ static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 73d8c79..95846c5 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1146,3 +1146,11 @@
  */
 #define QIHARDWARE_VID			0x20B7
 #define MILKYMISTONE_JTAGSERIAL_PID	0x0713
+
+/*
+ * CTI GmbH RS485 Converter http://www.cti-lean.com/
+ */
+/* USB-485-Mini*/
+#define FTDI_CTI_MINI_PID	0xF608
+/* USB-Nano-485*/
+#define FTDI_CTI_NANO_PID	0xF60B
-- 
1.7.9.3

