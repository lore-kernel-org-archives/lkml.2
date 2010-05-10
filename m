Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0EJJzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:55:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35899 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0EJJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a1ru3Ad8w10R7P2iibEnzs1+3pD2kEGNNJT8wrLp27F3HiFw1Be/xOdY06s3nIPuC/
         /buux5bqGROLN36VHJKDVmgkmd7GcyNwATl/I1UC6QxNoZKVNbhdggKse0DYL60lc3Sa
         JAaL3HpaDvM20fi3HwEUfAFH8SsHkFjkXSL4c=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, berndporr@f2s.com, revent82@gmail.com,
       shawn.bohrer@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fixed long line lengths in comedi.h
Date: Mon, 10 May 2010 17:56:05 +0800
Message-Id: <1273485365-4174-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes quite a few long line lengths in comedi.h as reported by
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi.h |   62 +++++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 20a6fee..1538146 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -156,15 +156,15 @@
 #define TRIG_ANY	0xffffffff
 #define TRIG_INVALID	0x00000000
 
-#define TRIG_NONE	0x00000001	/* never trigger */
-#define TRIG_NOW	0x00000002	/* trigger now + N ns */
-#define TRIG_FOLLOW	0x00000004	/* trigger on next lower level trig */
-#define TRIG_TIME	0x00000008	/* trigger at time N ns */
-#define TRIG_TIMER	0x00000010	/* trigger at rate N ns */
-#define TRIG_COUNT	0x00000020	/* trigger when count reaches N */
-#define TRIG_EXT	0x00000040	/* trigger on external signal N */
-#define TRIG_INT	0x00000080	/* trigger on comedi-internal signal N */
-#define TRIG_OTHER	0x00000100	/* driver defined */
+#define TRIG_NONE	0x00000001 /* never trigger */
+#define TRIG_NOW	0x00000002 /* trigger now + N ns */
+#define TRIG_FOLLOW	0x00000004 /* trigger on next lower level trig */
+#define TRIG_TIME	0x00000008 /* trigger at time N ns */
+#define TRIG_TIMER	0x00000010 /* trigger at rate N ns */
+#define TRIG_COUNT	0x00000020 /* trigger when count reaches N */
+#define TRIG_EXT	0x00000040 /* trigger on external signal N */
+#define TRIG_INT	0x00000080 /* trigger on comedi-internal signal N */
+#define TRIG_OTHER	0x00000100 /* driver defined */
 
 /* subdevice flags */
 
@@ -181,14 +181,17 @@
 #define SDF_MODE3	0x0400	/* can do mode 3 */
 #define SDF_MODE4	0x0800	/* can do mode 4 */
 #define SDF_CMD		0x1000	/* can do commands (deprecated) */
-#define SDF_SOFT_CALIBRATED	0x2000	/* subdevice uses software calibration */
-#define SDF_CMD_WRITE		0x4000	/* can do output commands */
-#define SDF_CMD_READ		0x8000	/* can do input commands */
-
-#define SDF_READABLE	0x00010000	/* subdevice can be read (e.g. analog input) */
-#define SDF_WRITABLE	0x00020000	/* subdevice can be written (e.g. analog output) */
+#define SDF_SOFT_CALIBRATED	0x2000 /* subdevice uses software calibration */
+#define SDF_CMD_WRITE		0x4000 /* can do output commands */
+#define SDF_CMD_READ		0x8000 /* can do input commands */
+
+/* subdevice can be read (e.g. analog input) */
+#define SDF_READABLE	0x00010000
+/* subdevice can be written (e.g. analog output) */
+#define SDF_WRITABLE	0x00020000
 #define SDF_WRITEABLE	SDF_WRITABLE	/* spelling error in API */
-#define SDF_INTERNAL	0x00040000	/* subdevice does not have externally visible lines */
+/* subdevice does not have externally visible lines */
+#define SDF_INTERNAL	0x00040000
 #define SDF_GROUND	0x00100000	/* can do aref=ground */
 #define SDF_COMMON	0x00200000	/* can do aref=common */
 #define SDF_DIFF	0x00400000	/* can do aref=diff */
@@ -255,15 +258,14 @@
 		INSN_CONFIG_GPCT_QUADRATURE_ENCODER = 1003,
 		INSN_CONFIG_SET_GATE_SRC = 2001,	/* Set gate source */
 		INSN_CONFIG_GET_GATE_SRC = 2002,	/* Get gate source */
-		INSN_CONFIG_SET_CLOCK_SRC = 2003,	/* Set master clock source */
-		INSN_CONFIG_GET_CLOCK_SRC = 2004,	/* Get master clock source */
-		INSN_CONFIG_SET_OTHER_SRC = 2005,	/* Set other source */
+		/* Set master clock source */
+		INSN_CONFIG_SET_CLOCK_SRC = 2003,
+		INSN_CONFIG_GET_CLOCK_SRC = 2004, /* Get master clock source */
+		INSN_CONFIG_SET_OTHER_SRC = 2005, /* Set other source */
 		/* INSN_CONFIG_GET_OTHER_SRC = 2006,*//* Get other source */
-		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,	/* Get size in bytes of
-								   subdevice's on-board
-								   fifos used during
-								   streaming
-								   input/output */
+		/* Get size in bytes of subdevice's on-board fifos used during
+		 * streaming input/output */
+		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,
 		INSN_CONFIG_SET_COUNTER_MODE = 4097,
 		INSN_CONFIG_8254_SET_MODE = INSN_CONFIG_SET_COUNTER_MODE,	/* deprecated */
 		INSN_CONFIG_8254_READ_STATUS = 4098,
@@ -273,8 +275,11 @@
 		INSN_CONFIG_PWM_SET_PERIOD = 5000,	/* sets frequency */
 		INSN_CONFIG_PWM_GET_PERIOD = 5001,	/* gets frequency */
 		INSN_CONFIG_GET_PWM_STATUS = 5002,	/* is it running? */
-		INSN_CONFIG_PWM_SET_H_BRIDGE = 5003,	/* sets H bridge: duty cycle and sign bit for a relay  at the same time */
-		INSN_CONFIG_PWM_GET_H_BRIDGE = 5004	/* gets H bridge data: duty cycle and the sign bit */
+		/* sets H bridge: duty cycle and sign bit for a relay at the
+		 * same time */
+		INSN_CONFIG_PWM_SET_H_BRIDGE = 5003,
+		/* gets H bridge data: duty cycle and the sign bit */
+		INSN_CONFIG_PWM_GET_H_BRIDGE = 5004
 	};
 
 	enum comedi_io_direction {
@@ -362,7 +367,7 @@
 		unsigned int __user *chanlist;	/* channel/range list */
 		unsigned int chanlist_len;
 
-		short __user *data;	/* data list, size depends on subd flags */
+		short __user *data; /* data list, size depends on subd flags */
 		unsigned int data_len;
 	};
 
@@ -395,7 +400,8 @@
 		unsigned int flags;	/* channel flags */
 		unsigned int range_type;	/* lookup in kernel */
 		unsigned int settling_time_0;
-		unsigned insn_bits_support;	/* see support_level enum for values */
+		/* see support_level enum for values */
+		unsigned insn_bits_support;
 		unsigned int unused[8];
 	};
 
-- 
1.7.0.5

