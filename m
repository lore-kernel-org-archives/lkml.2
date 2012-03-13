Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab2CMAWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:47707 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2CMAWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 070/196] USB: ftdi_sio: add PID for OCT DK201 docking station
Date: Mon, 12 Mar 2012 20:19:43 -0400
Message-Id: <1331598109-31424-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 11a31d84129dc3133417d626643d714c9df5317e upstream.

Add PID 0x0103 for serial port of the OCT DK201 docking station.

Reported-by: Jan Hoogenraad <jan@hoogenraad.net>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 193a59b..ecaad2b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -531,6 +531,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(SEALEVEL_VID, SEALEVEL_2803_8_PID) },
 	{ USB_DEVICE(IDTECH_VID, IDTECH_IDT1221U_PID) },
 	{ USB_DEVICE(OCT_VID, OCT_US101_PID) },
+	{ USB_DEVICE(OCT_VID, OCT_DK201_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_HE_TIRA1_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_HE_TIRA1_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_USB_UIRT_PID),
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 95846c5..069cc91 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -579,6 +579,7 @@
 /* Note: OCT US101 is also rebadged as Dick Smith Electronics (NZ) XH6381 */
 /* Also rebadged as Dick Smith Electronics (Aus) XH6451 */
 /* Also rebadged as SIIG Inc. model US2308 hardware version 1 */
+#define OCT_DK201_PID		0x0103	/* OCT DK201 USB docking station */
 #define OCT_US101_PID		0x0421	/* OCT US101 USB to RS-232 */
 
 /*
-- 
1.7.9.3

