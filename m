Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1B0Eej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1B0Eec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eZogZ9r2PO9uq3ZNwXQw23kNurwIh8tbhKOZpQ3F4flCAtHPSVKbZwS+tBckJu76GM
         /d7thUSIqtkDO3s5wRSyKVGVHometIeKuJJpX+p/4CoFEyalTgdE70W+5EMQ/eMYNJLv
         nTbvLPT7PNS568m1WqC9ctSauzf58aHCHtdqU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 01/17]drivers:dma:timb_dma.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:54 -0800
Message-Id: <1298781250-2718-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word.. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>  

---
 drivers/dma/timb_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 3b88a4e..f69f90a 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -629,7 +629,7 @@ static int td_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		desc_node)
 		list_move(&td_desc->desc_node, &td_chan->free_list);
 
-	/* now tear down the runnning */
+	/* now tear down the running */
 	__td_finish(td_chan);
 	spin_unlock_bh(&td_chan->lock);
 
-- 
1.7.4.1

