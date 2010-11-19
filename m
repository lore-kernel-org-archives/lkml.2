Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0KSWLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:11:17 -0500
Received: from kroah.org ([198.145.64.141]:52987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab0KSWEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:23 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:25 2010
Message-Id: <20101119220125.378802928@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kuba Ober <kuba@mareimbrium.org>
Subject: [39/66] USB: ftdi_sio: add device ids for ScienceScope
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 0f266abd70cd83571eca019f764b5f1992da7361 upstream.

This adds the requested device ids to the ftdi_sio driver.

Reported-by: Ewan Bingham <ewan@auc.co.uk>
Cc: Kuba Ober <kuba@mareimbrium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -791,6 +791,9 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MAXI_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_MEDIA_WING_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CHAMSYS_WING_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1095,3 +1095,8 @@
  * Accesio USB Data Acquisition products (http://www.accesio.com/)
  */
 #define ACCESIO_COM4SM_PID 	0xD578
+
+/* www.sciencescope.co.uk educational dataloggers */
+#define FTDI_SCIENCESCOPE_LOGBOOKML_PID		0xFF18
+#define FTDI_SCIENCESCOPE_LS_LOGBOOK_PID	0xFF1C
+#define FTDI_SCIENCESCOPE_HS_LOGBOOK_PID	0xFF1D


