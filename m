Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1ABHbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:31:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:37155 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1ABHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Rich Mattes <richmattes@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 243/260] USB: ftdi_sio: Add PID for accesio products
Date: Sun,  2 Jan 2011 02:18:59 -0500
Message-Id: <1293952756-15010-244-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:35.0496 (UTC) FILETIME=[1B742A80:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rich Mattes <richmattes@gmail.com>

commit 3126d8236ca6f68eb8292c6af22c2e59afbeef24 upstream.

Adds support for Accesio USB to Serial adapters, which are built around
FTDI FT232 UARTs.  Tested with the Accesio USB-COM-4SM.

Signed-off-by: Rich Mattes <richmattes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index fd5c874..9d810e8 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -757,6 +757,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, XVERVE_SIGNALYZER_SH4_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, SEGWAY_RMP200_PID) },
+	{ USB_DEVICE(FTDI_VID, ACCESIO_COM4SM_PID) },
 	{ USB_DEVICE(IONICS_VID, IONICS_PLUGCOMPUTER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_24_MASTER_WING_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 6eb1592..d3d2f48 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1070,3 +1070,9 @@
  * Submitted by John G. Rogers
  */
 #define SEGWAY_RMP200_PID	0xe729
+
+
+/*
+ * Accesio USB Data Acquisition products (http://www.accesio.com/)
+ */
+#define ACCESIO_COM4SM_PID 	0xD578
-- 
1.7.3.3

