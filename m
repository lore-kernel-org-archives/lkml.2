Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab1F1Ill (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:41:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34849 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1F1Ij4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:39:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jun 2011 17:31:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [FIX][PATCH 0/3] memcg: 3 fixes for memory cgroup's memory reclaim
Message-Id: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series contains 3 fixes for memcg in Linus's git tree.
All of them were posted in the last week. I cut out and refreshed
and post it here because I think all pathces has obvious benfits, I think.

All of patches are independent from each other but you may see
some dependency between 1 and 2.

1/3 .... fix memory cgroup reclaimable check.
2/3 .... fix memory cgroup numascan update by events
3/3 .... fix lock_page() trouble when using memcg.

Because 3/3 is a patch to change behavior of __do_fault(), I'd like
to get review of mm specialists.

Thanks,
-Kame

