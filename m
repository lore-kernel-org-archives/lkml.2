Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2JYM3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796Ab2JYM3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:29:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC] sb_edac: add a missing /n on a debug message
Date: Thu, 25 Oct 2012 10:29:37 -0200
Message-Id: <e93979b2f4e978de487ee208c2854c2071cc165f.1351168175.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   17.024963] EDAC DEBUG: get_memory_layout: TOHM: 132.160 GB (0x0000002043ffffff)<7>[   17.024971] EDAC DEBUG: get_memory_layout: SAD#0 DRAM up to 33.792 GB (0x0000000840000000) Interleave: 8:6 reg=0x000083c3

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/sb_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 5715b7c..9ad2424 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -639,7 +639,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	tmp_mb = (1 + pvt->tohm) >> 20;
 
 	mb = div_u64_rem(tmp_mb, 1000, &kb);
-	edac_dbg(0, "TOHM: %u.%03u GB (0x%016Lx)", mb, kb, (u64)pvt->tohm);
+	edac_dbg(0, "TOHM: %u.%03u GB (0x%016Lx)\n", mb, kb, (u64)pvt->tohm);
 
 	/*
 	 * Step 2) Get SAD range and SAD Interleave list
-- 
1.7.11.7

