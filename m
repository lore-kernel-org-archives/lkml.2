Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0DQIX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 04:23:27 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:59611 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0DQIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 04:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nJgkbY9DfJ4tGHC5AXrlZXd8zba+KH8Ovb5x28Fy3nRP/tCWrMeEgnEyI/vktvdH82
         28YvcSBjC0MFOdAy3vLBAxn6fW/BLPl5fbLHjPwgNm8St7SGHx9q577UDXPCkafRexy6
         UPpKDQoUOHqvIDgCNRxkw0P8nlestN21mcpx8=
Message-ID: <4BC96FF9.1090402@gmail.com>
Date: Sat, 17 Apr 2010 04:23:21 -0400
From: supermine290 <supermine290@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Bill Pemberton <wfp5p@virginia.edu>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Patch to comedi_fops.c
References: <4BB03C13.7090209@gmail.com> <20100329151904.GB12015@suse.de>
In-Reply-To: <20100329151904.GB12015@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb3bff4e8052a4075d82f1687e0338dc81d73256 Mon Sep 17 00:00:00 2001
From: Jakob Penzien <jakob@bloodmoon.(none)>
Date: Tue, 23 Mar 2010 12:52:14 -0400
Subject: [PATCH] Staging: comedi: fix space before tab style issue
in comedi_fops.c
 This is a patch to the comedi_fops.c file that fixes up a tab style
warning
 found by the checkpathc.pl tool. This patch was done to 2.6.34 kernel.
 Signed-off-by: Jakob Penzien <supermine290@gmail.com>

---
 drivers/staging/comedi/comedi_fops.c |   38
+++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c
b/drivers/staging/comedi/comedi_fops.c
index aca9674..5cb5bc7 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -598,19 +598,19 @@ copyback:
 static int parse_insn(struct comedi_device *dev, struct comedi_insn
*insn,
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
 static int do_insn_ioctl(struct comedi_device *dev, void *arg, void
*file)
 {
-- 
1.6.3.3

