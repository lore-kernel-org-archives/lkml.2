Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab0IIWpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:45:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61888 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab0IIWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eyhgpc/BaGOifgR5+8QNz+5ESzfEzwkiGTRJ5yYZOkiNh39xbYXFORSoG81CIhxV92
         e1ZpOvBEr7DOk4TBO+kZ8L/XrYje45NqUE6aljCWdjATWJQtOLIEhlUEHAXK7S3ym/MU
         rA2U79FV8jYINZrxw5TQCjy9jlJKIwamWVFLE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 207/223]drivers/usb/serial/ftdi_sio_ids.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:06 -0700
Message-Id: <1284072309-8452-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/serial/ftdi_sio_ids.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 2e95857..cd838ab 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -46,7 +46,7 @@
 #define FTDI_USINT_RS232_PID	0xb812	/* Navigator RS232 and CONFIG lines */
 
 /* OOCDlink by Joern Kaipf <joernk@web.de>
- * (http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink) */
+ * (http://www.joernonline.de/) */
 #define FTDI_OOCDLINK_PID	0xbaf8	/* Amontec JTAGkey */
 
 /* Luminary Micro Stellaris Boards, VID = FTDI_VID */
@@ -323,7 +323,7 @@
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 
 /* ACT Solutions HomePro ZWave interface
-   (http://www.act-solutions.com/HomePro.htm) */
+   (http://www.act-solutions.com/index.php) */
 #define FTDI_ACTZWAVE_PID	0xF2D0
 
 /*
@@ -354,7 +354,7 @@
 #define FTDI_SUUNTO_SPORTS_PID	0xF680	/* Suunto Sports instrument */
 
 /* USB-UIRT - An infrared receiver and transmitter using the 8U232AM chip */
-/* http://home.earthlink.net/~jrhees/USBUIRT/index.htm */
+/* http://www.usbuirt.com/ */
 #define FTDI_USB_UIRT_PID	0xF850	/* Product Id */
 
 /* CCS Inc. ICDU/ICDU40 product ID -
@@ -383,7 +383,7 @@
  */
 #define FTDI_HE_TIRA1_PID	0xFA78	/* Tira-1 IR transceiver */
 
-/* Inside Accesso contactless reader (http://www.insidefr.com) */
+/* Inside Accesso contactless reader (http://www.insidecontactless.com/) */
 #define INSIDE_ACCESSO		0xFAD0
 
 /*
@@ -422,7 +422,7 @@
 
 /*
  * PCDJ use ftdi based dj-controllers. The following PID is
- * for their DAC-2 device http://www.pcdjhardware.com/DAC2.asp
+ * for their DAC-2 device 
  * (the VID is the standard ftdi vid (FTDI_VID), PID sent by Wouter Paesen)
  */
 #define FTDI_PCDJ_DAC2_PID 0xFA88
@@ -622,14 +622,14 @@
 
 /*
  * JETI SPECTROMETER SPECBOS 1201
- * http://www.jeti.com/products/sys/scb/scb1201.php
+ * http://www.jeti.com/cms/index.php 
  */
 #define JETI_VID		0x0c6c
 #define JETI_SPC1201_PID	0x04b2
 
 /*
  * FTDI USB UART chips used in construction projects from the
- * Elektor Electronics magazine (http://elektor-electronics.co.uk)
+ * Elektor Electronics magazine (http://www.elektor.com/)
  */
 #define ELEKTOR_VID		0x0C7D
 #define ELEKTOR_FT323R_PID	0x0005	/* RFID-Reader, issue 09-2006 */
@@ -711,7 +711,7 @@
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
- * http://winglucofacts.com/cables/
+ * http://www.simplewins.com/Default.aspx 
  */
 #define BAYER_VID                      0x1A79
 #define BAYER_CONTOUR_CABLE_PID        0x6001
-- 
1.7.2.1

