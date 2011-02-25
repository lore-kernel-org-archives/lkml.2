Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1BYGOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:14:25 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54013 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1BYGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nv1dOuhKpnD39Vkyx2pDM89bzta5cOWJl5w41KaJIUwM05lybYZISAtjkHxZdEz1L3
         eOAlDmDuYeRRoiGhonPKAmKS6J2InMNsF9tPoZ8pPho8+6KycGEXBAQJZQUv41ywzJCi
         VmWphZSqQbp5YQNyYa49Fnbcz5yiQDYzm35jc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 14/21]drivers:staging:comedi:pcl818.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:14:05 -0800
Message-Id: <1298614445-3997-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/comedi/drivers/pcl818.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index d2bd6f8..f58d75b 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -261,7 +261,7 @@ struct pcl818_board {
 	int n_ranges;		/*  len of range list */
 	int n_aichan_se;	/*  num of A/D chans in single ended  mode */
 	int n_aichan_diff;	/*  num of A/D chans in diferencial mode */
-	unsigned int ns_min;	/*  minimal alllowed delay between samples (in ns) */
+	unsigned int ns_min;	/*  minimal allowed delay between samples (in ns) */
 	int n_aochan;		/*  num of D/A chans */
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
@@ -349,7 +349,7 @@ struct pcl818_private {
 	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
 	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
 	unsigned char neverending_ai;	/*  if=1, then we do neverending record (you must use cancel()) */
-	unsigned int ns_min;	/*  manimal alllowed delay between samples (in us) for actual card */
+	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
-- 
1.7.4.1

