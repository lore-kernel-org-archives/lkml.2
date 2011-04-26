Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab1DZV0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:26:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab1DZVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831878"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: simon@swine.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [67/106] USB: ftdi_sio: Added IDs for CTI USB Serial Devices
Message-Id: <20110426211348.4B26D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Simon <simon@swine.de>

commit 5a9443f08c83c294c5c806a689c1184b27cb26b3 upstream.

I added new ProdutIds for two devices from CTI GmbH Leipzig.

Signed-off-by: Christian Simon <simon@swine.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    9 +++++++++
 2 files changed, 11 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
@@ -150,6 +150,8 @@ static struct ftdi_sio_quirk ftdi_stmcli
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
@@ -1140,3 +1140,12 @@
 #define QIHARDWARE_VID			0x20B7
 #define MILKYMISTONE_JTAGSERIAL_PID	0x0713
 
+/*
+ * CTI GmbH RS485 Converter http://www.cti-lean.com/
+ */
+/* USB-485-Mini*/
+#define FTDI_CTI_MINI_PID	0xF608
+/* USB-Nano-485*/
+#define FTDI_CTI_NANO_PID	0xF60B
+
+
