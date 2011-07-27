Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1G0WBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:01:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:50745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1G0Vs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826388"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: sledz@dresearch-fe.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [50/99] USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver
Message-Id: <20110727214849.399042403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Steffen Sledz <sledz@dresearch-fe.de>

commit a26d31cef06f43a76327c21235e75450869df2b8 upstream.

E.g. newer CAN 2.0 A/B <=> USB 2.0 converters report idProduct=f3c2.

Signed-off-by: Steffen Sledz <sledz@dresearch-fe.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
@@ -646,6 +646,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_3_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_0_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_1_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_2_PID) },
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -351,6 +351,7 @@
  */
 #define FTDI_4N_GALAXY_DE_1_PID	0xF3C0
 #define FTDI_4N_GALAXY_DE_2_PID	0xF3C1
+#define FTDI_4N_GALAXY_DE_3_PID	0xF3C2
 
 /*
  * Linx Technologies product ids
