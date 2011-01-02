Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1ABHaC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:30:02 -0500
Received: from mail.windriver.com ([147.11.1.11]:37169 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1ABHZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Rainer Keller <mail@rainerkeller.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 244/260] USB: add PID for FTDI based OpenDCC hardware
Date: Sun,  2 Jan 2011 02:19:00 -0500
Message-Id: <1293952756-15010-245-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:36.0511 (UTC) FILETIME=[1C0F0AF0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Keller <mail@rainerkeller.de>

commit 99c1e4f89d1033444ce4d0c064bd2826e81c3775 upstream.

The OpenDCC project is developing a new hardware. This patch adds its
PID to the list of known FTDI devices. The PID can be found at
http://www.opendcc.de/elektronik/usb/opendcc_usb.html

Signed-off-by: Rainer Keller <mail@rainerkeller.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9d810e8..f2fbf78 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -182,6 +182,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_SNIFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index d3d2f48..a214917 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -61,6 +61,7 @@
 #define FTDI_OPENDCC_SNIFFER_PID	0xBFD9
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
+#define FTDI_OPENDCC_GBM_PID	0xBFDC
 
 /*
  * RR-CirKits LocoBuffer USB (http://www.rr-cirkits.com)
-- 
1.7.3.3

