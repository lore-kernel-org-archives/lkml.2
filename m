Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0LGPJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:09:55 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43394 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0LGPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gkHkhVEQ50mP4JDNj9U2nrIER8ajDhzG8sieppATecfmGvYjOey3UL86Ye7rE3G9mj
         LWs4a6pCsxihUFoly9/CcNNJgJoNUnE9k3TNtjP4Plv1vuMKheo4yw6h3P87z7MhKyWg
         sU9XgPCUV29oiMG7koehEj751YakflxVvSoRE=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] memcg: Remove unnecessary return
Date: Wed,  8 Dec 2010 00:09:40 +0900
Message-Id: <1291734580-19515-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memcontrol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f9435be..55f57e3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -821,7 +821,6 @@ void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
-	return;
 }
 
 void mem_cgroup_del_lru(struct page *page)
-- 
1.7.0.4

