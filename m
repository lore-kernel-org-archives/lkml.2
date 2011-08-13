Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1HMA0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:26:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1HMA0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:26:40 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/4]drivers:atm:iphase.c Fix a typo "shud"
Date: Fri, 12 Aug 2011 17:26:12 -0700
Message-Id: <1313195174-4464-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
References: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes a typo shud.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/atm/iphase.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index cb90f7a..bc6bf9e 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -1089,7 +1089,7 @@ static int rx_pkt(struct atm_dev *dev)
                                     iadev->reass_ram, iadev->rfL.pcq_rd, desc);
               printk(" pcq_wr_ptr = 0x%x\n",
                                readw(iadev->reass_reg+PCQ_WR_PTR)&0xffff);)
-	/* update the read pointer  - maybe we shud do this in the end*/  
+	/* update the read pointer  - maybe we should do this in the end*/  
 	if ( iadev->rfL.pcq_rd== iadev->rfL.pcq_ed) 
 		iadev->rfL.pcq_rd = iadev->rfL.pcq_st;  
 	else  
@@ -1167,7 +1167,7 @@ static int rx_pkt(struct atm_dev *dev)
 	wr_ptr->bytes = len;	/* We don't know this do we ?? */  
 	wr_ptr->mode = DMA_INT_ENABLE;  
   
-	/* shud take care of wrap around here too. */  
+	/* should take care of wrap around here too. */  
         if(++wr_ptr == iadev->rx_dle_q.end)
              wr_ptr = iadev->rx_dle_q.start;
 	iadev->rx_dle_q.write = wr_ptr;  
@@ -2509,7 +2509,7 @@ static int __devinit ia_start(struct atm_dev *dev)
 			| CTRL_B64  
 			| CTRL_B128  
 			| CTRL_ERRMASK  
-			| CTRL_DLETMASK		/* shud be removed l8r */  
+			| CTRL_DLETMASK		/* should be removed l8r */  
 			| CTRL_DLERMASK  
 			| CTRL_SEGMASK  
 			| CTRL_REASSMASK 	  
-- 
1.7.6

