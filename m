Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab2EOCRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52937 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab2EOCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 027/179] USB: serial: ftdi_sio: adding support for TavIR STK500
Date: Mon, 14 May 2012 22:12:03 -0400
Message-ID: <1337048075-6132-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedek László <benedekl@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 37909fe588c9e09ab57cd267e98678a17ceda64a upstream.

Adding support for the TavIR STK500 (id 0403:FA33)
Atmel AVR programmer device based on FTDI FT232RL.

Signed-off-by: Benedek László <benedekl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7d0107a..eac7330 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -570,6 +570,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_APP70_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	/*
 	 * ELV devices:
 	 */
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index aaeb159..a644665 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -491,6 +491,11 @@
 /* www.canusb.com Lawicel CANUSB device (FTDI_VID) */
 #define FTDI_CANUSB_PID 0xFFA8 /* Product Id */
 
+/*
+ * TavIR AVR product ids (FTDI_VID)
+ */
+#define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
+
 
 
 /********************************/
-- 
1.7.9.6

