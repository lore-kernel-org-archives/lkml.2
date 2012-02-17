Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2BQJ1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:27:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50600 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2BQJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:26:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 18:25:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 1/6] memcg: remove
 EXPORT_SYMBOL(mem_cgroup_update_page_stat)
Message-Id: <20120217182535.6a17ec72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7075e575cc6ee383f8fd161ba44c44a60c295d5f Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 12:05:41 +0900
Subject: [PATCH 1/6] memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)

>From the log, I guess EXPORT was for preparing dirty accounting.
But _now_, we don't need to export this. Remove this for now.

Reviewed-by: Greg Thelen <gthelen@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab315ab..4c2b759 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1897,7 +1897,6 @@ out:
 		move_unlock_page_cgroup(pc, &flags);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_update_page_stat);
 
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
-- 
1.7.4.1


