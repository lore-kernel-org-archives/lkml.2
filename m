Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2HOUVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:21:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:36840 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab2HOTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hakan Kvist <hakan.kvist@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 077/165] USB: ftdi_sio: add PID for Sony Ericsson Urban
Date: Wed, 15 Aug 2012 15:47:01 -0400
Message-ID: <1345060109-9187-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Kvist <hakan.kvist@sonyericsson.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 74bdf22b5c3858b06af46f19d05c23e76c40a3bb upstream.

Add PID 0xfc8a, 0xfc8b for device Sony Ericsson Urban

Signed-off-by: Hakan Kvist <hakan.kvist@sonyericsson.com>
Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e8bc908..27cd4a1 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -209,6 +209,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_640_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_642_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DSS20_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_0_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_1_PID) },
 	{ USB_DEVICE(FTDI_NF_RIC_VID, FTDI_NF_RIC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VNHCPCUSB_D_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_0_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index a73443f..7d7f138 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -419,9 +419,11 @@
 #define PROTEGO_SPECIAL_4	0xFC73	/* special/unknown device */
 
 /*
- * DSS-20 Sync Station for Sony Ericsson P800
+ * Sony Ericsson product ids
  */
-#define FTDI_DSS20_PID          0xFC82
+#define FTDI_DSS20_PID		0xFC82	/* DSS-20 Sync Station for Sony Ericsson P800 */
+#define FTDI_URBAN_0_PID	0xFC8A	/* Sony Ericsson Urban, uart #0 */
+#define FTDI_URBAN_1_PID	0xFC8B	/* Sony Ericsson Urban, uart #1 */
 
 /* www.irtrans.de device */
 #define FTDI_IRTRANS_PID 0xFC60 /* Product Id */
-- 
1.7.12.rc2

