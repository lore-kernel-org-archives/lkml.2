Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2BFKK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:10:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60916 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2BFKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:10:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Feb 2012 19:09:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC] [PATCH 2/6 v3]  memcg: remove
 EXPORT_SYMBOL(mem_cgroup_update_page_stat)
Message-Id: <20120206190907.4167f834.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal pointed out this.

>From 78dfe92250046397114148e57bbc5927c59257fe Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 12:05:41 +0900
Subject: [PATCH 2/6] memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)

>From the log, I guess EXPORT was for preparing dirty accounting.
But _now_, we don't need to export this. Remove this for now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9bf9d1c..4ba0d76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1896,7 +1896,6 @@ out:
 		move_unlock_page_cgroup(pc, &flags);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_update_page_stat);
 
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
-- 
1.7.4.1


