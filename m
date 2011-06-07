Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1FGSzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:55:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1FGSzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:55:45 -0400
From: Steffen Sledz <sledz@dresearch-fe.de>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Steffen Sledz <sledz@dresearch-fe.de>
Subject: [PATCH] usb/serial: add another 4N-GALAXY.DE PID to ftdi_sio driver
Date: Tue,  7 Jun 2011 14:01:56 +0200
Message-Id: <1307448116-22606-1-git-send-email-sledz@dresearch-fe.de>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E.g. newer CAN 2.0 A/B <=> USB 2.0 converters report idProduct=f3c2.

Signed-off-by: Steffen Sledz <sledz@dresearch-fe.de>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e8dbde5..1627289 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -647,6 +647,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_3_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_0_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_1_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1d946cd..ab1fcdf 100644
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
1.7.5.4

