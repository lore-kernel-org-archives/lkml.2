Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0FBBFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:05:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44709 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab0FBBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:05:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Jun 2010 10:00:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] memcg remove experimental from swap account config
Message-Id: <20100602100038.34149d10.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's 11 months since we changed swap_map[] to indicates SWAP_HAS_CACHE.
Since that, memcg's swap accounting has been very stable and it seems
it can be maintained.

So, I'd like to remove EXPERIMENTAL from the config.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 init/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: mmotm-2.6.34-May21/init/Kconfig
===================================================================
--- mmotm-2.6.34-May21.orig/init/Kconfig
+++ mmotm-2.6.34-May21/init/Kconfig
@@ -577,8 +577,8 @@ config CGROUP_MEM_RES_CTLR
 	  could in turn add some fork/exit overhead.
 
 config CGROUP_MEM_RES_CTLR_SWAP
-	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
-	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
+	bool "Memory Resource Controller Swap Extension"
+	depends on CGROUP_MEM_RES_CTLR && SWAP
 	help
 	  Add swap management feature to memory resource controller. When you
 	  enable this, you can limit mem+swap usage per cgroup. In other words,

