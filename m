Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1AYGDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:03:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51783 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1AYGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:03:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Jan 2011 14:57:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/3] 3 bugfixes for memory cgroup (2.6.38-rc2)
Message-Id: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi, these are 3 bugfix patches for 2.6.38-rc2 + 
 mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
in mm tree.

3 patches are independent from each other but [1/3] patch is for
2.6.36-stable, tree.

[1/3] fix account leak at failure of memsw acconting. (for 2.6.36 stable)
[2/3] check mem_cgroup_disabled() at split fixup (for recent 2.6.38-git)
[3/3] fix race at move_parent() (This depends on m-memcontrolc
      fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch)

I'll send other fixes for THP/memcg but this is an early cut for obvious bugs.

Thanks,
-Kame

