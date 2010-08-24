Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab0HXXER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:04:17 -0400
Received: from kroah.org ([198.145.64.141]:32913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab0HXXDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:54 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:11 2010
Message-Id: <20100824224511.023184303@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Galen Seitz <galens@seitzassoc.com>
Subject: [112/114] USB: ftdi_sio: add product ID for Lenz LI-USB
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Galen Seitz <galens@seitzassoc.com>

commit ea233f805537f5da16c2b34d85b6c5cf88a0f9aa upstream.

Add ftdi product ID for Lenz LI-USB, a model train interface.  This
was NOT tested against 2.6.35, but a similar patch was tested with the
CentOS 2.6.18-194.11.1.el5 kernel.  It wasn't clear to me what
ordering is being used in ftdi_sio.c, so I inserted the ID after another
model train entry(SPROG_II).

Signed-off-by: Galen Seitz <galens@seitzassoc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -180,6 +180,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_547_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -110,6 +110,9 @@
 /* Propox devices */
 #define FTDI_PROPOX_JTAGCABLEII_PID	0xD738
 
+/* Lenz LI-USB Computer Interface. */
+#define FTDI_LENZ_LIUSB_PID	0xD780
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */


