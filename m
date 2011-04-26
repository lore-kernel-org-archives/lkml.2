Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1DZVO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1DZVOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483687"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: Paul.Friedrich@hameg.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [69/106] USB: ftdi_sio: add ids for Hameg HO720 and HO730
Message-Id: <20110426211350.6853D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Paul Friedrich <Paul.Friedrich@hameg.com>

commit c53c2fab40cf16e13af66f40bfd27200cda98d2f upstream.

usb serial: ftdi_sio: add two missing USB ID's for Hameg interfaces HO720
and HO730

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
@@ -787,6 +787,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO720_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO730_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_GENERIC_PID) },
 	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -300,6 +300,8 @@
  * Hameg HO820 and HO870 interface (using VID 0x0403)
  */
 #define HAMEG_HO820_PID			0xed74
+#define HAMEG_HO730_PID			0xed73
+#define HAMEG_HO720_PID			0xed72
 #define HAMEG_HO870_PID			0xed71
 
 /*
