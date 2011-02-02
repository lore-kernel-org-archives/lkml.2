Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1BBA4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:56:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab1BBAoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622563"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: faberman@linuxproaudio.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [99/139] USB: ftdi_sio: Add D.O.Tec PID
Message-Id: <20110202004457.5C6313E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Faber <faberman@linuxproaudio.org>

commit 5363cdc3c5da9bd431552cf5989ab481596f0c6d upstream.

Add FTDI PID to identify D.O.Tec devices correctly.

Signed-off-by: Florian Faber <faberman@linuxproaudio.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 6 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
@@ -796,6 +796,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -1081,6 +1081,11 @@
 #define MJSG_HD_RADIO_PID	0x937C
 
 /*
+ * D.O.Tec products (http://www.directout.eu)
+ */
+#define FTDI_DOTEC_PID 0x9868
+
+/*
  * Xverve Signalyzer tools (http://www.signalyzer.com/)
  */
 #define XVERVE_SIGNALYZER_ST_PID	0xBCA0
