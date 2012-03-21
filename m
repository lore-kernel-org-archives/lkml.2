Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2CUJpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab2CUJpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:45:53 -0400
Date: Wed, 21 Mar 2012 10:45:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>, Hugh Dickins <hughd@google.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>
Subject: memcg-devel updated for v3.3
Message-ID: <20120321094545.GA10450@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for few days delay]

Hi,
The memcg-devel tree hosted at github[*] has been updated to 3.3. Like
with the previous releases the current patch queue is sitting in the
since-3.3 branch based on v3.3 linus tree.

We are currently at 37 patches comparing to 74 in the previous cycle
which looks like a quite nice reduction.

Andrew Morton (7):
      memcg-clear-pc-mem_cgorup-if-necessary-fix
      memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix
      memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
      memcg-simplify-move_account-check-fix
      memcg-use-new-logic-for-page-stat-accounting-fix
      memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix
      mm/memcontrol.c: s/stealed/stolen/

Anton Vorontsov (1):
      mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()

Hugh Dickins (15):
      memcg-clear-pc-mem_cgorup-if-necessary-fix-2
      memcg-clear-pc-mem_cgorup-if-necessary fix 3
      memcg: fix page migration to reset_owner
      memcg: replace MEM_CONT by MEM_RES_CTLR
      memcg: replace mem and mem_cont stragglers
      memcg: lru_size instead of MEM_CGROUP_ZSTAT
      memcg: enum lru_list lru
      memcg: remove redundant returns
      idr: make idr_get_next() good for rcu_read_lock()
      cgroup: revert ss_id_lock to spinlock
      memcg: let css_get_next() rely upon rcu_read_lock()
      memcg: remove PCG_CACHE page_cgroup flag fix
      memcg: remove PCG_CACHE page_cgroup flag fix2
      memcg: remove PCG_FILE_MAPPED fix cosmetic fix
      memcg: fix GPF when cgroup removal races with last exit

Jeff Liu (1):
      mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()

Johannes Weiner (1):
      memcg-clear-pc-mem_cgorup-if-necessary-comments

KAMEZAWA Hiroyuki (10):
      memcg: clear pc->mem_cgorup if necessary.
      memcg: remove unnecessary thp check in page stat accounting
      memcg: remove PCG_CACHE page_cgroup flag
      memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
      memcg: simplify move_account() check
      memcg: remove PCG_MOVE_LOCK flag from page_cgroup
      memcg: use new logic for page stat accounting
      memcg: remove PCG_FILE_MAPPED
      memcg-remove-pcg_file_mapped-fix
      memcg: fix performance of mem_cgroup_begin_update_page_stat()

Konstantin Khlebnikov (1):
      memcg: kill dead prev_priority stubs

Li Zefan (1):
      cgroup: remove cgroup_subsys argument from callbacks


Happy hacking and have a lot of fun.

Let me know if I missed any patches.

---
[*] git://github.com/mstsxfx/memcg-devel.git
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
