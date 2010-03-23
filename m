Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0CWRGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:06:42 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:37612 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0CWRGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=EPxHEcJH5RgUEETfpxOf1Js+TFiOBvMQ1CaMmi4BINpQDPHRRKAd2P69HRbJz7AHxx
         likYp5DklOdEl3KSz6NbrEsKsQJ8VnGmfybNnclz/zs4CqvyGiLlWo7MFFE7l15lxIif
         J/22WkBALPws60J++wNBenppyNrfg2REkngHY=
Message-ID: <4BA8F51E.4090302@gmail.com>
Date: Tue, 23 Mar 2010 13:06:38 -0400
From: supermine290 <supermine290@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       Shawn Bohrer <shawn.bohrer@gmail.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Patch to comedi_fops.c
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb3bff4e8052a4075d82f1687e0338dc81d73256 Mon Sep 17 00:00:00 2001
From: Jakob Penzien <jakob@bloodmoon.(none)>
Date: Tue, 23 Mar 2010 12:52:14 -0400
Subject: [PATCH] Staging: comedi: fix space before tab style issue in comedi_fops.c
 This is a patch to the comedi_fops.c file that fixes up a tab style warning
 found by the checkpathc.pl tool. This patch was done to 2.6.34 kernel.
 Signed-off-by: Jakob Penzien <supermine290@gmail.com>

---
 drivers/staging/comedi/comedi_fops.c |   38 +++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index aca9674..5cb5bc7 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -598,19 +598,19 @@ copyback:
 static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 		      unsigned int *data, void *file);
 /*
- * 	COMEDI_INSNLIST
- * 	synchronous instructions
+ *     COMEDI_INSNLIST
+ *     synchronous instructions
  *
- * 	arg:
- * 		pointer to sync cmd structure
+ *     arg:
+ *          pointer to sync cmd structure
  *
- * 	reads:
- * 		sync cmd struct at arg
- * 		instruction list
- * 		data (for writes)
+ *     reads:
+ *          sync cmd struct at arg
+ *          instruction list
+ *          data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *     writes:
+ *            data (for reads)
  */
 /* arbitrary limits */
 #define MAX_SAMPLES 256
@@ -894,18 +894,18 @@ out:
 }
 
 /*
- * 	COMEDI_INSN
- * 	synchronous instructions
+ *     COMEDI_INSN
+ *     synchronous instructions
  *
- * 	arg:
- * 		pointer to insn
+ *     arg:
+ *             pointer to insn
  *
- * 	reads:
- * 		struct comedi_insn struct at arg
- * 		data (for writes)
+ *     reads:
+ *             struct comedi_insn struct at arg
+ *             data (for writes)
  *
- * 	writes:
- * 		data (for reads)
+ *     writes:
+ *             data (for reads)
  */
 static int do_insn_ioctl(struct comedi_device *dev, void *arg, void *file)
 {
-- 
1.6.3.3
