Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0G2FZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:25:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59820 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0G2FZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:25:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 0/5] memcg: few nit fix and cleanups
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 14:25:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes were a part of memcg tracepoint series. and now It was divided
from such series. All patches are trivial. 



KOSAKI Motohiro (5):
  memcg: sc.nr_to_reclaim should be initialized
  memcg: kill unnecessary initialization
  memcg: mem_cgroup_shrink_node_zone() doesn't need sc.nodemask
  memcg: remove nid and zid argument from mem_cgroup_soft_limit_reclaim()
  memcg: convert to use zone_to_nid() from bare zone->zone_pgdat->node_id

 include/linux/memcontrol.h |    6 +++---
 include/linux/swap.h       |    3 +--
 mm/memcontrol.c            |   14 ++++++--------
 mm/vmscan.c                |   15 ++++-----------
 4 files changed, 14 insertions(+), 24 deletions(-)



