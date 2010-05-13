Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab0EMWor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:44:47 -0400
Received: from [95.158.236.142] ([95.158.236.142]:55467 "EHLO
	desktop.system.ru" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758310Ab0EMWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:44:46 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 18:44:46 EDT
From: akummail@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akummail@gmail.com
Subject: [PATCH] Staring: comedi: fix space coding style issue in comedi_fops.c This is patch to the comedi_fops.c  file fixes up space warning found by the checkpatch.pl tool. Signed-off-by: Stalmakov Vladimir <akummail@gmail.com>
Date: Fri, 14 May 2010 02:37:19 +0400
Message-Id: <1273790239-2102-1-git-send-email-akummail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir <akum@Desktop-System.(none)>

---
 drivers/staging/comedi/comedi_fops.c |   38 +++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index aca9674..3d6b40e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -598,19 +598,19 @@ copyback:
 static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 		      unsigned int *data, void *file);
 /*
- * 	COMEDI_INSNLIST
- * 	synchronous instructions
+ *	COMEDI_INSNLIST
+ *	synchronous instructions
  *
- * 	arg:
- * 		pointer to sync cmd structure
+ *	arg:
+ *		pointer to sync cmd structure
  *
- * 	reads:
- * 		sync cmd struct at arg
- * 		instruction list
- * 		data (for writes)
+ *	reads:
+ *		sync cmd struct at arg
+ *		instruction list
+ *		data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *	writes:
+ *		data (for reads)
  */
 /* arbitrary limits */
 #define MAX_SAMPLES 256
@@ -894,18 +894,18 @@ out:
 }
 
 /*
- * 	COMEDI_INSN
- * 	synchronous instructions
+ *	COMEDI_INSN
+ *	synchronous instructions
  *
- * 	arg:
- * 		pointer to insn
+ *	arg:
+ *		pointer to insn
  *
- * 	reads:
- * 		struct comedi_insn struct at arg
- * 		data (for writes)
+ *	reads:
+ *		struct comedi_insn struct at arg
+ *		data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *	writes:
+ *		data (for reads)
  */
 static int do_insn_ioctl(struct comedi_device *dev, void *arg, void *file)
 {
-- 
1.7.0.4

