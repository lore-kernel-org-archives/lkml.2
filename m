Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0EFCkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:40:17 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:48971 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0EFCkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JqT4zCgA93LaghjbeV2TVl84/Bpkuw4FeGT5GCeUwV96PG+4r51ERW7Y1rVwzfZkeX
         nKSs+01KcT8qllciV9iAImr0+54JEUqWdQyzVgqVtO66YSa0vMWxyo9UAOe8DfxwZe9F
         MyBWQa9ZeZ9aawu6XSYaoF/TD4x5Zs8VahcXY=
From: Zachary Richey <zr.public@gmail.com>
To: gregkh@suse.de, fmhess@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Zachary Richey <zr.public@gmail.com>
Subject: [PATCH] Staging: comedi: fix coding style issues in comedi_fops.c This patch fixes coding style issues reported by scripts/checkpatch.pl Signed-off-by: Zachary Richey <zr.public@gmail.com>
Date: Wed,  5 May 2010 22:39:47 -0400
Message-Id: <1273113587-2809-1-git-send-email-zr.public@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/comedi_fops.c |   56 +++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index aca9674..999cbb6 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -598,20 +598,20 @@ copyback:
 static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 		      unsigned int *data, void *file);
 /*
- * 	COMEDI_INSNLIST
- * 	synchronous instructions
- *
- * 	arg:
- * 		pointer to sync cmd structure
- *
- * 	reads:
- * 		sync cmd struct at arg
- * 		instruction list
- * 		data (for writes)
- *
- * 	writes:
- * 		data (for reads)
- */
+*	COMEDI_INSNLIST
+*	synchronous instructions
+*
+*	arg:
+*		pointer to sync cmd structure
+*
+*	reads:
+*		sync cmd struct at arg
+*		instruction list
+*		data (for writes)
+*
+*	writes:
+*		data (for reads)
+*/
 /* arbitrary limits */
 #define MAX_SAMPLES 256
 static int do_insnlist_ioctl(struct comedi_device *dev, void *arg, void *file)
@@ -736,7 +736,7 @@ static int check_insn_config_length(struct comedi_insn *insn,
 		/* by default we allow the insn since we don't have checks for
 		 * all possible cases yet */
 	default:
-		printk("comedi: no check for data length of config insn id "
+		printk(KERN_DEBUG "comedi: no check for data length of config insn id "
 		       "%i is implemented.\n"
 		       " Add a check to %s in %s.\n"
 		       " Assuming n=%i is correct.\n", data[0], __func__,
@@ -894,19 +894,19 @@ out:
 }
 
 /*
- * 	COMEDI_INSN
- * 	synchronous instructions
- *
- * 	arg:
- * 		pointer to insn
- *
- * 	reads:
- * 		struct comedi_insn struct at arg
- * 		data (for writes)
- *
- * 	writes:
- * 		data (for reads)
- */
+*	COMEDI_INSN
+*	synchronous instructions
+*
+*	arg:
+*		pointer to insn
+*
+*	reads:
+*		struct comedi_insn struct at arg
+*		data (for writes)
+*
+*	writes:
+*		data (for reads)
+*/
 static int do_insn_ioctl(struct comedi_device *dev, void *arg, void *file)
 {
 	struct comedi_insn insn;
-- 
1.6.3.3

