Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab1FWSbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:31:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:62910 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759897Ab1FWRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Michael Williamson <michael.h.williamson@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 023/247] USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph
Date: Thu, 23 Jun 2011 13:17:46 -0400
Message-Id: <1308849690-14530-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Williamson <michael.h.williamson@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 28fe2eb0162a1d23370dd99ff7d0e35632b1ee91 upstream.

Add the USB Vendor ID and Product ID for a Acton Research Corp.
spectrograph device with a FTDI chip for serial I/O.

Signed-off-by: Michael H Williamson <michael.h.williamson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f4b2527..05dcaa0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -625,6 +625,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5f3f5da..73d8c79 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -518,6 +518,12 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Acton Research Corp.
+ */
+#define ACTON_VID		0x0647	/* Vendor ID */
+#define ACTON_SPECTRAPRO_PID	0x0100
+
+/*
  * Contec products (http://www.contec.com)
  * Submitted by Daniel Sangorrin
  */
-- 
1.7.4.4

