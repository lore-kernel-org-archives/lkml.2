Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657Ab1KCBlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934506Ab1KCBll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:45 2011
Message-Id: <20111102222745.784757050@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hakan Kvist <hakan.kvist@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [066/101] USB: ftdi_sio: add PID for Sony Ericsson Urban
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hakan Kvist <hakan.kvist@sonyericsson.com>

commit 74bdf22b5c3858b06af46f19d05c23e76c40a3bb upstream.

Add PID 0xfc8a, 0xfc8b for device Sony Ericsson Urban

Signed-off-by: Hakan Kvist <hakan.kvist@sonyericsson.com>
Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -205,6 +205,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_640_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_642_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DSS20_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_0_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_1_PID) },
 	{ USB_DEVICE(FTDI_NF_RIC_VID, FTDI_NF_RIC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VNHCPCUSB_D_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_0_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -399,9 +399,11 @@
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


