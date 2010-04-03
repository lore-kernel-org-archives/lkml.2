Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0DCGTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 02:19:18 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:43157 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0DCGTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 02:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SotDmmLXOCQJcHPUhEoMk/zySMpUBZ91y942+i+GzPf3I6JRAxRkjWqakm1e6QsoY1
         O9B0kvx9KoWUdaMIObxykrH9fuiw03Ep3r0fzetNBFdqlmMeYN3ewX/sFkW5IldD/hwN
         IBK3bt95spbUv3cEBEcTKWGBnlVDJ0LrHK0zk=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, berndporr@f2s.com,
       shawn.bohrer@gmail.com, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 8/8] Staging:comedi: fix coding style issue in comedi.h
Date: Sat,  3 Apr 2010 12:18:25 +0600
Message-Id: <1270275505-18498-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the comedi.h files that fixes up errors found by the
checkpatch.pl tool

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/comedi/comedi.h |   55 +++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index b559a9c..8b2c219 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -490,7 +490,8 @@
 		I8254_BINARY = 0
 	};
 
-	static inline unsigned NI_USUAL_PFI_SELECT(unsigned pfi_channel) {
+	static inline unsigned NI_USUAL_PFI_SELECT(unsigned pfi_channel)
+{
 		if (pfi_channel < 10)
 			return 0x1 + pfi_channel;
 		else
@@ -590,14 +591,17 @@
 		NI_GPCT_PRESCALE_X8_CLOCK_SRC_BITS = 0x20000000,	/* divide source by 8 */
 		NI_GPCT_INVERT_CLOCK_SRC_BIT = 0x80000000
 	};
-	static inline unsigned NI_GPCT_SOURCE_PIN_CLOCK_SRC_BITS(unsigned n) {
+	static inline unsigned NI_GPCT_SOURCE_PIN_CLOCK_SRC_BITS(unsigned n)
+	{
 		/* NI 660x-specific */
 		return 0x10 + n;
 	}
-	static inline unsigned NI_GPCT_RTSI_CLOCK_SRC_BITS(unsigned n) {
+	static inline unsigned NI_GPCT_RTSI_CLOCK_SRC_BITS(unsigned n)
+	{
 		return 0x18 + n;
 	}
-	static inline unsigned NI_GPCT_PFI_CLOCK_SRC_BITS(unsigned n) {
+	static inline unsigned NI_GPCT_PFI_CLOCK_SRC_BITS(unsigned n)
+	{
 		/* no pfi on NI 660x */
 		return 0x20 + n;
 	}
@@ -625,16 +629,20 @@ May be bitwise-or'd with CR_EDGE or CR_INVERT. */
 		   we should add them here with an offset of 0x300 when known. */
 		NI_GPCT_DISABLED_GATE_SELECT = 0x8000,
 	};
-	static inline unsigned NI_GPCT_GATE_PIN_GATE_SELECT(unsigned n) {
+	static inline unsigned NI_GPCT_GATE_PIN_GATE_SELECT(unsigned n)
+	{
 		return 0x102 + n;
 	}
-	static inline unsigned NI_GPCT_RTSI_GATE_SELECT(unsigned n) {
+	static inline unsigned NI_GPCT_RTSI_GATE_SELECT(unsigned n)
+	{
 		return NI_USUAL_RTSI_SELECT(n);
 	}
-	static inline unsigned NI_GPCT_PFI_GATE_SELECT(unsigned n) {
+	static inline unsigned NI_GPCT_PFI_GATE_SELECT(unsigned n)
+	{
 		return NI_USUAL_PFI_SELECT(n);
 	}
-	static inline unsigned NI_GPCT_UP_DOWN_PIN_GATE_SELECT(unsigned n) {
+	static inline unsigned NI_GPCT_UP_DOWN_PIN_GATE_SELECT(unsigned n)
+	{
 		return 0x202 + n;
 	}
 
@@ -650,7 +658,8 @@ INSN_CONFIG_SET_OTHER_SRC when using NI general-purpose counters. */
 		/* Still unknown, probably only need NI_GPCT_PFI_OTHER_SELECT */
 		NI_GPCT_DISABLED_OTHER_SELECT = 0x8000,
 	};
-	static inline unsigned NI_GPCT_PFI_OTHER_SELECT(unsigned n) {
+	static inline unsigned NI_GPCT_PFI_OTHER_SELECT(unsigned n)
+	{
 		return NI_USUAL_PFI_SELECT(n);
 	}
 
@@ -699,7 +708,8 @@ INSN_CONFIG_ARM */
 		NI_MIO_PLL_PXI10_CLOCK = 3,
 		NI_MIO_PLL_RTSI0_CLOCK = 4
 	};
-	static inline unsigned NI_MIO_PLL_RTSI_CLOCK(unsigned rtsi_channel) {
+	static inline unsigned NI_MIO_PLL_RTSI_CLOCK(unsigned rtsi_channel)
+	{
 		return NI_MIO_PLL_RTSI0_CLOCK + rtsi_channel;
 	}
 
@@ -719,7 +729,8 @@ INSN_CONFIG_ARM */
 		NI_RTSI_OUTPUT_RTSI_OSC = 12	/* pre-m-series always have RTSI clock
 						   on line 7 */
 	};
-	static inline unsigned NI_RTSI_OUTPUT_RTSI_BRD(unsigned n) {
+	static inline unsigned NI_RTSI_OUTPUT_RTSI_BRD(unsigned n)
+	{
 		return NI_RTSI_OUTPUT_RTSI_BRD_0 + n;
 	}
 
@@ -754,7 +765,8 @@ INSN_CONFIG_ARM */
 		NI_PFI_OUTPUT_CDI_SAMPLE = 29,
 		NI_PFI_OUTPUT_CDO_UPDATE = 30
 	};
-	static inline unsigned NI_PFI_OUTPUT_RTSI(unsigned rtsi_channel) {
+	static inline unsigned NI_PFI_OUTPUT_RTSI(unsigned rtsi_channel)
+	{
 		return NI_PFI_OUTPUT_RTSI0 + rtsi_channel;
 	}
 
@@ -772,10 +784,12 @@ INSN_CONFIG_ARM */
 /* NI External Trigger lines.  These values are not arbitrary, but are related
  * to the bits required to program the board (offset by 1 for historical
  * reasons). */
-	static inline unsigned NI_EXT_PFI(unsigned pfi_channel) {
+	static inline unsigned NI_EXT_PFI(unsigned pfi_channel)
+	{
 		return NI_USUAL_PFI_SELECT(pfi_channel) - 1;
 	}
-	static inline unsigned NI_EXT_RTSI(unsigned rtsi_channel) {
+	static inline unsigned NI_EXT_RTSI(unsigned rtsi_channel)
+	{
 		return NI_USUAL_RTSI_SELECT(rtsi_channel) - 1;
 	}
 
@@ -801,21 +815,24 @@ INSN_CONFIG_ARM */
 		NI_CDIO_SCAN_BEGIN_SRC_FREQ_OUT = 32,
 		NI_CDIO_SCAN_BEGIN_SRC_DIO_CHANGE_DETECT_IRQ = 33
 	};
-	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_PFI(unsigned pfi_channel) {
+	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_PFI(unsigned pfi_channel)
+	{
 		return NI_USUAL_PFI_SELECT(pfi_channel);
 	}
-	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned
-							   rtsi_channel) {
+	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
+	{
 		return NI_USUAL_RTSI_SELECT(rtsi_channel);
 	}
 
 /* scan_begin_src for scan_begin_arg==TRIG_EXT with analog output command on NI
  * boards.  These scan begin sources can also be bitwise-or'd with CR_INVERT to
  * change polarity. */
-	static inline unsigned NI_AO_SCAN_BEGIN_SRC_PFI(unsigned pfi_channel) {
+	static inline unsigned NI_AO_SCAN_BEGIN_SRC_PFI(unsigned pfi_channel)
+	{
 		return NI_USUAL_PFI_SELECT(pfi_channel);
 	}
-	static inline unsigned NI_AO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel) {
+	static inline unsigned NI_AO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
+	{
 		return NI_USUAL_RTSI_SELECT(rtsi_channel);
 	}
 
-- 
1.7.0.3

