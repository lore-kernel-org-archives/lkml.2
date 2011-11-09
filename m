Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1KJFYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:24:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934006Ab1KJDWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:05 2011
Message-Id: <20111109212705.440081226@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hakan Kvist <hakan.kvist@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [051/262] USB: ftdi_sio: add PID for Sony Ericsson Urban
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -206,6 +206,8 @@ static struct usb_device_id id_table_com
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
@@ -420,9 +420,11 @@
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


