Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3AHXhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:63574 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3AHXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Marcin=20Ko=C5=9Bcielnicki?= <koriakin@0x04.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 34/77] usb: ftdi_sio: add PID for Propox ISPcable III
Date: Tue, 8 Jan 2013 18:35:13 -0500
Message-ID: <1357688156-25387-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Kościelnicki <koriakin@0x04.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 307369b0ca06b27b511b61714e335ddfccf19c4f upstream.

Signed-off-by: Marcin Kościelnicki <koriakin@0x04.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e4c3da1..646cc53 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -739,6 +739,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELSTER_UNICOM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_JTAGCABLEII_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_ISPCABLEIII_PID) },
 	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FIC_VID, FIC_NEO1973_DEBUG_PID),
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index c4670e5..ce57c40 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -111,6 +111,7 @@
 
 /* Propox devices */
 #define FTDI_PROPOX_JTAGCABLEII_PID	0xD738
+#define FTDI_PROPOX_ISPCABLEIII_PID	0xD739
 
 /* Lenz LI-USB Computer Interface. */
 #define FTDI_LENZ_LIUSB_PID	0xD780
-- 
1.7.12.1

