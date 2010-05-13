Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0EMK2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:28:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0EMK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U9ELpGGXTadoG7nWlREmuDt4uMz81NYughQNlJAGC2ayCoI3cSQmkxl/NqkPOXG3vh
         NaZXmJMlDpLFxk801++QDD0ESk8qi3EubqycSDbU5C+Qt7J9JyiNb85GYfnOZmETg31O
         mw3aFeSMb1jcAZBO9qDmHvqV4pgBDfaybTpzA=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bernd Porr <berndporr@f2s.com>,
       Gorskin Ilya <revent82@gmail.com>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: comedi: Fixed long line lengths in comedi.h
Date: Thu, 13 May 2010 18:28:38 +0800
Message-Id: <1273746519-4590-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes long line lengths in comedi.h that were picked up by
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi.h |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 1538146..3e3663f 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -465,7 +465,8 @@
 
 #define COMEDI_CB_EOS		1	/* end of scan */
 #define COMEDI_CB_EOA		2	/* end of acquisition */
-#define COMEDI_CB_BLOCK		4	/* data has arrived: wakes up read() / write() */
+#define COMEDI_CB_BLOCK		4	/* data has arrived:
+					 * wakes up read() / write() */
 #define COMEDI_CB_EOBUF		8	/* DEPRECATED: end of buffer */
 #define COMEDI_CB_ERROR		16	/* card error during acquisition */
 #define COMEDI_CB_OVERFLOW	32	/* buffer overflow/underflow */
@@ -499,8 +500,10 @@
 		I8254_MODE2 = (2 << 1),	/* Rate generator */
 		I8254_MODE3 = (3 << 1),	/* Square wave mode */
 		I8254_MODE4 = (4 << 1),	/* Software triggered strobe */
-		I8254_MODE5 = (5 << 1),	/* Hardware triggered strobe (retriggerable) */
-		I8254_BCD = 1,	/* use binary-coded decimal instead of binary (pretty useless) */
+		I8254_MODE5 = (5 << 1),	/* Hardware triggered strobe
+					 * (retriggerable) */
+		I8254_BCD = 1,	/* use binary-coded decimal instead of binary
+				 * (pretty useless) */
 		I8254_BINARY = 0
 	};
 
@@ -640,7 +643,8 @@ May be bitwise-or'd with CR_EDGE or CR_INVERT. */
 		NI_GPCT_UP_DOWN_PIN_i_GATE_SELECT = 0x201,
 		NI_GPCT_SELECTED_GATE_GATE_SELECT = 0x21e,
 		/* m-series "second gate" sources are unknown,
-		   we should add them here with an offset of 0x300 when known. */
+		 * we should add them here with an offset of 0x300 when
+		 * known. */
 		NI_GPCT_DISABLED_GATE_SELECT = 0x8000,
 	};
 	static inline unsigned NI_GPCT_GATE_PIN_GATE_SELECT(unsigned n)
@@ -681,14 +685,14 @@ INSN_CONFIG_SET_OTHER_SRC when using NI general-purpose counters. */
 INSN_CONFIG_ARM */
 	enum ni_gpct_arm_source {
 		NI_GPCT_ARM_IMMEDIATE = 0x0,
-		NI_GPCT_ARM_PAIRED_IMMEDIATE = 0x1,	/* Start both the counter and
-							   the adjacent paired counter
-							   simultaneously */
-		/* NI doesn't document bits for selecting hardware arm triggers.  If
-		 * the NI_GPCT_ARM_UNKNOWN bit is set, we will pass the least
-		 * significant bits (3 bits for 660x or 5 bits for m-series) through to
-		 * the hardware.  This will at least allow someone to figure out what
-		 * the bits do later. */
+		NI_GPCT_ARM_PAIRED_IMMEDIATE = 0x1, /* Start both the counter
+						     * and the adjacent paired
+						     * counter simultaneously */
+		/* NI doesn't document bits for selecting hardware arm triggers.
+		 * If the NI_GPCT_ARM_UNKNOWN bit is set, we will pass the least
+		 * significant bits (3 bits for 660x or 5 bits for m-series)
+		 * through to the hardware.  This will at least allow someone to
+		 * figure out what the bits do later. */
 		NI_GPCT_ARM_UNKNOWN = 0x1000,
 	};
 
@@ -740,8 +744,8 @@ INSN_CONFIG_ARM */
 		NI_RTSI_OUTPUT_G_GATE0 = 6,
 		NI_RTSI_OUTPUT_RGOUT0 = 7,
 		NI_RTSI_OUTPUT_RTSI_BRD_0 = 8,
-		NI_RTSI_OUTPUT_RTSI_OSC = 12	/* pre-m-series always have RTSI clock
-						   on line 7 */
+		NI_RTSI_OUTPUT_RTSI_OSC = 12	/* pre-m-series always have RTSI
+						 * clock on line 7 */
 	};
 	static inline unsigned NI_RTSI_OUTPUT_RTSI_BRD(unsigned n)
 	{
-- 
1.7.0.5

