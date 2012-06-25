Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2FYLPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:15:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48213 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2FYLPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:15:14 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v4 0/2] memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 19:15:00 +0800
Message-Id: <1340622900-13034-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Changelog:

* drop memcg: move recent_rotated and recent_scanned informations patch
* drop memcg: replace unsigned long by u64 to avoid overflow
* not add Add LRU_ALL_UNEVICTABLE
* drop memcg: cleanup all typo in memory cgroup, if it really need, I will resend in single patch
* drop memcg: optimize memcg_get_hierarchical_limit 

Wanpeng Li (2):

memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx

---
 include/linux/mmzone.h |    1 -
 mm/memcontrol.c        |   8 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)
-- 
1.7.9.5

