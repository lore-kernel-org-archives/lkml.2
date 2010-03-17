Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab0CQCxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:53:25 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:37232 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0CQCxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ny1M3Zh2rtdwtfYNNAm/iJrvJmqXWWMzMvYaxi0dJ5bkmKlsVZo7AKAffqynYHVMFx
         PGVb768V6ZbTyMmcfzCfTw7ABP1bpjASczyO8SSGFmX5hfxaJDsay7mdJkTPBdCGWIiW
         vLHa2l/bR55zLHwC7ueUiKw1o87pKcelAHyyA=
From: baslangenberg@gmail.com
To: gregkh@suse.de, wfp5p@virginia.edu, shawn.bohrer@gmail.com,
       fmhess@users.sourceforge.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fixes all space before tabs warnings in drivers/staging/comedi/comedi_fops.c This is patch that tends to fix all WARNING: no space before tab warnings in drivers/staging/comedi/comedi_fops.c Signed-off-by: Bas Langenberg <baslangenberg@gmail.com>
Date: Wed, 17 Mar 2010 03:53:26 +0100
Message-Id: <1268794406-3405-1-git-send-email-baslangenberg@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <baslangenberg@gmail.com>
References: <baslangenberg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bas Langenberg <bas@Bas-Mint.(none)>

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
1.6.3.3

