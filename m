Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1GLHF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:05:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34055 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1GLHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:05:58 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 20/20] Staging: comedi: fix warning: line over 80 character issue in pcl812.c
Date: Tue, 12 Jul 2011 12:48:40 +0530
Message-Id: <1310455120-20416-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in pcl812.c>
References: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in pcl812.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl812.c file that fixes up a  warning:line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 6fc7464..157cbde 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -433,14 +433,16 @@ struct pcl812_private {
 	unsigned char range_correction;	/*  =1 we must add 1 to range number */
 	unsigned char old_chan_reg;	/*  lastly used chan/gain pair */
 	unsigned char old_gain_reg;
-	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
+	unsigned char mode_reg_int;	/* there is stored INT number for some
+					 * card */
 	unsigned char ai_neverending;	/*  =1 we do unlimited AI */
 	unsigned char ai_eos;	/*  1=EOS wake up */
 	unsigned char ai_dma;	/*  =1 we use DMA */
 	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
 	unsigned int ai_scans;	/*  len of scanlist */
 	unsigned int ai_act_scan;	/*  how many scans we finished */
-	unsigned int ai_chanlist[MAX_CHANLIST_LEN];	/*  our copy of channel/range list */
+	/* our copy of channel/range list */
+	unsigned int ai_chanlist[MAX_CHANLIST_LEN];
 	unsigned int ai_n_chan;	/*  how many channels is measured */
 	unsigned int ai_flags;	/*  flaglist */
 	unsigned int ai_data_len;	/*  len of data buffer */
@@ -452,9 +454,12 @@ struct pcl812_private {
 	unsigned int hwdmasize[2];	/*  DMA buf size in bytes */
 	unsigned int dmabytestomove[2];	/*  how many bytes DMA transfer */
 	int next_dma_buf;	/*  which buffer is next to use */
-	unsigned int dma_runs_to_end;	/*  how many times we must switch DMA buffers */
-	unsigned int last_dma_run;	/*  how many bytes to transfer on last DMA buffer */
-	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
+	/* how many times we must switch DMA buffers */
+	unsigned int dma_runs_to_end;
+	/* how many bytes to transfer on last DMA buffer */
+	unsigned int last_dma_run;
+	/* setling time for gain */
+	unsigned int max_812_ai_mode0_rangewait;
 	unsigned int ao_readback[2];	/*  data for AO readback */
 };
 
-- 
1.6.5.2

