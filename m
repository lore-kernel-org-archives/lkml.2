Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0HNS4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:56:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0HNS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=MqL0XNzZ5duaYF+vcSXwJuSmvTy3PWen6M2+kopfhCE39pU0ZAD1X1rd+yo/TXF7xz
         bakZF9ifb+2RSZz5EUIK1rSgfv6afvxati3BknH1zKSHX4q0jDlp6V8aqb51NPPeCF5T
         PG6XyUpKtOEanWZxvSYsZLwDH2wXiwgueGMyQ=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, rich.folsom@gmail.com, mithlesh@linsyssoft.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: comedi: fix no space before tabs coding style issue in adl_pci9111.c
Date: Sat, 14 Aug 2010 19:56:18 +0100
Message-Id: <1281812178-2062-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9111.c file that fixes up the no space before tabs warning found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   58 +++++++++++++-------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 6cd245d..73ef4e7 100755
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -38,11 +38,11 @@ Supports:
   - do_insn read/write
   - ai_do_cmd mode with the following sources:
 
-    - start_src 		TRIG_NOW
-    - scan_begin_src 		TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
-    - convert_src				TRIG_TIMER	TRIG_EXT
-    - scan_end_src		TRIG_COUNT
-    - stop_src			TRIG_COUNT	TRIG_NONE
+    -start_src		TRIG_NOW
+    - scan_begin_src	TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
+    - convert_src			TRIG_TIMER	TRIG_EXT
+    - scan_end_src	TRIG_COUNT
+    - stop_src		TRIG_COUNT	TRIG_NONE
 
     The scanned channels must be consecutive and start from 0. They must
     all have the same range and aref.
@@ -83,12 +83,12 @@ TODO:
 #include "comedi_pci.h"
 #include "comedi_fc.h"
 
-#define PCI9111_DRIVER_NAME 	"adl_pci9111"
-#define PCI9111_HR_DEVICE_ID 	0x9111
+#define PCI9111_DRIVER_NAME	"adl_pci9111"
+#define PCI9111_HR_DEVICE_ID	0x9111
 
 /*  TODO: Add other pci9111 board id */
 
-#define PCI9111_IO_RANGE 	0x0100
+#define PCI9111_IO_RANGE	0x0100
 
 #define PCI9111_FIFO_HALF_SIZE	512
 
@@ -134,28 +134,28 @@ TODO:
 
 /* IO address map */
 	/* AD Data stored in FIFO */
-#define PCI9111_REGISTER_AD_FIFO_VALUE 			0x00
-#define PCI9111_REGISTER_DA_OUTPUT 			0x00
-#define PCI9111_REGISTER_DIGITAL_IO 			0x02
-#define PCI9111_REGISTER_EXTENDED_IO_PORTS 		0x04
+#define PCI9111_REGISTER_AD_FIFO_VALUE			0x00
+#define PCI9111_REGISTER_DA_OUTPUT			0x00
+#define PCI9111_REGISTER_DIGITAL_IO			0x02
+#define PCI9111_REGISTER_EXTENDED_IO_PORTS		0x04
 	/* Channel selection */
-#define PCI9111_REGISTER_AD_CHANNEL_CONTROL 		0x06
-#define PCI9111_REGISTER_AD_CHANNEL_READBACK 		0x06
-#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE 		0x08
-#define PCI9111_REGISTER_RANGE_STATUS_READBACK 		0x08
-#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL 		0x0A
-#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK 	0x0A
-#define PCI9111_REGISTER_SOFTWARE_TRIGGER 		0x0E
-#define PCI9111_REGISTER_INTERRUPT_CONTROL 		0x0C
+#define PCI9111_REGISTER_AD_CHANNEL_CONTROL		0x06
+#define PCI9111_REGISTER_AD_CHANNEL_READBACK		0x06
+#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE		0x08
+#define PCI9111_REGISTER_RANGE_STATUS_READBACK		0x08
+#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL		0x0A
+#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK	0x0A
+#define PCI9111_REGISTER_SOFTWARE_TRIGGER		0x0E
+#define PCI9111_REGISTER_INTERRUPT_CONTROL		0x0C
 #define PCI9111_REGISTER_8254_COUNTER_0			0x40
 #define PCI9111_REGISTER_8254_COUNTER_1			0x42
-#define PCI9111_REGISTER_8254_COUNTER_2 		0X44
+#define PCI9111_REGISTER_8254_COUNTER_2			0X44
 #define PCI9111_REGISTER_8254_CONTROL			0x46
-#define PCI9111_REGISTER_INTERRUPT_CLEAR 		0x48
+#define PCI9111_REGISTER_INTERRUPT_CLEAR		0x48
 
-#define PCI9111_TRIGGER_MASK 				0x0F
-#define PCI9111_PTRG_OFF 				(0 << 3)
-#define PCI9111_PTRG_ON 				(1 << 3)
+#define PCI9111_TRIGGER_MASK				0x0F
+#define PCI9111_PTRG_OFF				(0 << 3)
+#define PCI9111_PTRG_ON					(1 << 3)
 #define PCI9111_EITS_EXTERNAL				(1 << 2)
 #define PCI9111_EITS_INTERNAL				(0 << 2)
 #define PCI9111_TPST_SOFTWARE_TRIGGER			(0 << 1)
@@ -165,9 +165,9 @@ TODO:
 
 #define PCI9111_ISC0_SET_IRQ_ON_ENDING_OF_AD_CONVERSION (0 << 0)
 #define PCI9111_ISC0_SET_IRQ_ON_FIFO_HALF_FULL		(1 << 0)
-#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK  		(0 << 1)
-#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG 		(1 << 1)
-#define PCI9111_FFEN_SET_FIFO_ENABLE 			(0 << 2)
+#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK		(0 << 1)
+#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG			(1 << 1)
+#define PCI9111_FFEN_SET_FIFO_ENABLE			(0 << 2)
 #define PCI9111_FFEN_SET_FIFO_DISABLE			(1 << 2)
 
 #define PCI9111_CHANNEL_MASK				0x0F
@@ -378,7 +378,7 @@ struct pci9111_private_data {
 	short ai_bounce_buffer[2 * PCI9111_FIFO_HALF_SIZE];
 };
 
-#define dev_private 	((struct pci9111_private_data *)dev->private)
+#define dev_private	((struct pci9111_private_data *)dev->private)
 
 /*  ------------------------------------------------------------------ */
 /*  PLX9050 SECTION */
-- 
1.7.0.4

