Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab1DNRyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:54:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:38434 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346Ab1DNRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jacques Viviers <jacques.viviers@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 087/209] USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added
Date: Thu, 14 Apr 2011 13:41:57 -0400
Message-Id: <1302803039-9400-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacques Viviers <jacques.viviers@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 6fdbad8021151a9e93af8159a6232c8f26415c09 upstream.

Add the PID for the Vardaan Enterprises VEUSB422R3 USB to RS422/485
converter. It uses the same chip as the FTDI_8U232AM_PID 0x6001.

This should also work with the stable branches for:
2.6.31, 2.6.32, 2.6.33, 2.6.34, 2.6.35, 2.6.36

Signed-off-by: Jacques Viviers <jacques.viviers@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 513b5a6..fd8f96e 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -206,6 +206,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_5_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
+	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e06f014..e6d7af6 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -114,6 +114,9 @@
 /* Lenz LI-USB Computer Interface. */
 #define FTDI_LENZ_LIUSB_PID	0xD780
 
+/* Vardaan Enterprises Serial Interface VEUSB422R3 */
+#define FTDI_VARDAAN_PID	0xF070
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
-- 
1.7.4.4

