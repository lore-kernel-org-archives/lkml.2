Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2KPJ0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:26:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2KPJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:26:39 -0500
X-IronPort-AV: E=Sophos;i="4.83,263,1352044800"; 
   d="scan'208";a="6214063"
From: liguang <lig.fnst@cn.fujitsu.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH]cputime: make bool type for steal ticks
Date: Fri, 16 Nov 2012 17:24:50 +0800
Message-Id: <1353057890-24234-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/16 17:26:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/16 17:26:30,
	Serialize complete at 2012/11/16 17:26:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/sched/cputime.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..d2c24c1 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -282,7 +282,7 @@ static __always_inline bool steal_account_process_tick(void)
 		this_rq()->prev_steal_time += st * TICK_NSEC;
 
 		account_steal_time(st);
-		return st;
+		return !!st;
 	}
 #endif
 	return false;
-- 
1.7.1

