Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1CCGYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:24:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab1CCGYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:24:12 -0500
Message-ID: <4D6F348C.2050804@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 14:26:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf cgroup: Fix a typo in kernel config
References: <4D6F3461.6060406@cn.fujitsu.com>
In-Reply-To: <4D6F3461.6060406@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:23:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:23:01,
	Serialize complete at 2011-03-03 14:23:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/specificied/specified

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 20d6bd9..4c4edf2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -688,7 +688,7 @@ config CGROUP_PERF
 	depends on PERF_EVENTS && CGROUPS
 	help
 	  This option extends the per-cpu mode to restrict monitoring to
-	  threads which belong to the cgroup specificied and run on the
+	  threads which belong to the cgroup specified and run on the
 	  designated cpu.
 
 	  Say N if unsure.
-- 
1.6.3
