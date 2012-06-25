Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2FYGFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:05:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34200 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2FYGFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:05:34 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v2] mm/memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 14:05:23 +0800
Message-Id: <1340604323-8004-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Changelog:

* drop memcg: move recent_rotated and recent_scanned informations patch
* fix  zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'

Wanpeng Li (6):

memcg: replace unsigned long by u64 to avoid overflow
memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx
memcg: optimize memcg_get_hierarchical_limit
memcg: cleanup all typo in memory cgroup

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 include/linux/mmzone.h |    2 +-
 include/linux/vmstat.h |    2 +-
 mm/memcontrol.c        |   40 +++++++++++++++++++---------------------
 3 files changed, 21 insertions(+), 23 deletions(-)
