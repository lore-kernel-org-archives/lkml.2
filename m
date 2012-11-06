Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2KFHN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:13:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13302 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2KFHN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:13:27 -0500
X-IronPort-AV: E=Sophos;i="4.80,721,1344182400"; 
   d="scan'208";a="6146224"
From: liguang <lig.fnst@cn.fujitsu.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH]cputime: make bool type for steal ticks
Date: Tue, 6 Nov 2012 15:12:16 +0800
Message-Id: <1352185936-17165-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/06 15:12:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/06 15:12:31,
	Serialize complete at 2012/11/06 15:12:31
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

