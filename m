Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab1CDLwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:52:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:41928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1CDLwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:52:39 -0500
Date: Fri, 4 Mar 2011 11:52:08 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6F348C.2050804@cn.fujitsu.com>
References: <4D6F348C.2050804@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf cgroup: Fix a typo in kernel config
Message-ID: <tip-2d0f25201ee210a0666ec9c41538ba05a07f8bc6@git.kernel.org>
Git-Commit-ID: 2d0f25201ee210a0666ec9c41538ba05a07f8bc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:52:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d0f25201ee210a0666ec9c41538ba05a07f8bc6
Gitweb:     http://git.kernel.org/tip/2d0f25201ee210a0666ec9c41538ba05a07f8bc6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 3 Mar 2011 14:26:20 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:51 +0100

perf cgroup: Fix a typo in kernel config

s/specificied/specified

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4D6F348C.2050804@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
