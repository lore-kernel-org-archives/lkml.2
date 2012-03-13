Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2CMA6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:58:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:47768 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2CMAWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Friedrich <Paul.Friedrich@hameg.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 071/196] USB: ftdi_sio: add ids for Hameg HO720 and HO730
Date: Mon, 12 Mar 2012 20:19:44 -0400
Message-Id: <1331598109-31424-26-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Friedrich <Paul.Friedrich@hameg.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c53c2fab40cf16e13af66f40bfd27200cda98d2f upstream.

usb serial: ftdi_sio: add two missing USB ID's for Hameg interfaces HO720
and HO730

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ecaad2b..7d0107a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -793,6 +793,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_GENERIC_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 069cc91..aaeb159 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -300,6 +300,8 @@
  * Hameg HO820 and HO870 interface (using VID 0x0403)
  */
 #define        HAMEG_HO820_PID         0xed74
+#define        HAMEG_HO730_PID         0xed73
+#define        HAMEG_HO720_PID         0xed72
 #define        HAMEG_HO870_PID         0xed71
 
 /*
-- 
1.7.9.3

