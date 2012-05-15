Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965761Ab2EOCSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53168 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab2EOCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 060/179] USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver
Date: Mon, 14 May 2012 22:12:36 -0400
Message-ID: <1337048075-6132-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Sledz <sledz@dresearch-fe.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a26d31cef06f43a76327c21235e75450869df2b8 upstream.

E.g. newer CAN 2.0 A/B <=> USB 2.0 converters report idProduct=f3c2.

Signed-off-by: Steffen Sledz <sledz@dresearch-fe.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index eac7330..c7e4fb8 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -651,6 +651,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_3_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_0_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_1_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index a644665..a73443f 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -351,6 +351,7 @@
  */
 #define FTDI_4N_GALAXY_DE_1_PID	0xF3C0
 #define FTDI_4N_GALAXY_DE_2_PID	0xF3C1
+#define FTDI_4N_GALAXY_DE_3_PID	0xF3C2
 
 /*
  * Linx Technologies product ids
-- 
1.7.9.6

