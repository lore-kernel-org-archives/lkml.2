Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1G0VsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:59981 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1G0VsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826273"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: benedekl@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [15/99] USB: serial: ftdi_sio: adding support for TavIR STK500
Message-Id: <20110727214813.934352403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Benedek=20L=C3=A1szl=C3=B3?= <benedekl@gmail.com>

commit 37909fe588c9e09ab57cd267e98678a17ceda64a upstream.

Adding support for the TavIR STK500 (id 0403:FA33)
Atmel AVR programmer device based on FTDI FT232RL.

Signed-off-by: Benedek László <benedekl@gmail.com>
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
@@ -565,6 +565,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_APP70_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	/*
 	 * ELV devices:
 	 */
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -491,6 +491,11 @@
 /* www.canusb.com Lawicel CANUSB device (FTDI_VID) */
 #define FTDI_CANUSB_PID 0xFFA8 /* Product Id */
 
+/*
+ * TavIR AVR product ids (FTDI_VID)
+ */
+#define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
+
 
 
 /********************************/
