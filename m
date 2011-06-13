Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1FMDIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:08:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52242 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1FMDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:08:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 12:00:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH 0/5] memcg bugfixes in the last week.
Message-Id: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the last week, I(and memcg people) posted 5 bug fixes.
I was slightly confued. 

For making things clearer, I post all 5 patches again,
which are I'm now testing. 

If I miss some patches/fixes/bugs, please notify me. 

[1/5] - fix memory.numa_stat permission (this is in mmotm)
[2/5] - fix init_page_cgroup() nid with sparsemem
[3/5] - fix mm->owner update
[4/5] - fix wrong check of noswap with softlimit
[5/5] - fix percpu cached charge draining.


Thank you for all your helps. 

Thanks,
-Kame

