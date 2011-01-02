Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1ABHaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:30:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:37156 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1ABHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kuba Ober <kuba@mareimbrium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 246/260] USB: ftdi_sio: add device ids for ScienceScope
Date: Sun,  2 Jan 2011 02:19:02 -0500
Message-Id: <1293952756-15010-247-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:38.0746 (UTC) FILETIME=[1D6413A0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 0f266abd70cd83571eca019f764b5f1992da7361 upstream.

This adds the requested device ids to the ftdi_sio driver.

Reported-by: Ewan Bingham <ewan@auc.co.uk>
Cc: Kuba Ober <kuba@mareimbrium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d2ea458..55ff244 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -797,6 +797,9 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MAXI_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MEDIA_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index ff8a8ad..4addf78 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1102,3 +1102,8 @@
  * Accesio USB Data Acquisition products (http://www.accesio.com/)
  */
 #define ACCESIO_COM4SM_PID 	0xD578
+
+/* www.sciencescope.co.uk educational dataloggers */
+#define FTDI_SCIENCESCOPE_LOGBOOKML_PID		0xFF18
+#define FTDI_SCIENCESCOPE_LS_LOGBOOK_PID	0xFF1C
+#define FTDI_SCIENCESCOPE_HS_LOGBOOK_PID	0xFF1D
-- 
1.7.3.3

