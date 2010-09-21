Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0IUJg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:36:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48196 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab0IUJg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:36:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Sep 2010 18:31:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3][-mm] memcg: memory cgroup cput hotplug support
 update
Message-Id: <20100921183127.1c4c2bc1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I rewrote memcg-memory-cgroup-cpu-hotplug-support-update.patch completely.
And the patch is divided into 3 part.

1/3 clean up ... delete mem_cgroup_walk_tree and add for_each_mem_cgroup_tree()
2/3 usual counters.... handles usual percpu statistics.
3/3 on_move ... handles special counters works as a kind of lock.

The direction is not different from previous one but implementation is re-designed.
I think all review comments are reflected...any comments are welcome.

Thanks,
-Kame

