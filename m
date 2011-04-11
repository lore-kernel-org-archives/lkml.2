Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1DKH7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:59:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59820 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1DKH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:59:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Subject: [patch 0/3 resend] mm, mem-hotplug: proper maintainance zone attribute when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110411165957.0352.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 16:59:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is resending very old patch. The code has no change.


KOSAKI Motohiro (3):
  mm, mem-hotplug: fix section mismatch.
    setup_per_zone_inactive_ratio() should be __meminit.
  mm, mem-hotplug: recalculate lowmem_reserve when memory hotplug occur
  mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur

 include/linux/mm.h     |    2 +-
 include/linux/vmstat.h |    1 +
 mm/memory_hotplug.c    |   13 +++++++------
 mm/page_alloc.c        |    8 +++++---
 mm/vmstat.c            |    3 +--
 5 files changed, 15 insertions(+), 12 deletions(-)

-- 
1.7.3.1



