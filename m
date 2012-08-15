Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2HOL3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:29:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HOL3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:29:20 -0400
Date: Wed, 15 Aug 2012 04:29:02 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-c7660994ed6b44d17dad0aac0d156da1e0a2f003@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, alex.shi@intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, alex.shi@intel.com,
        fengguang.wu@intel.com
In-Reply-To: <502AF3E6.3050709@intel.com>
References: <502AF3E6.3050709@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] tile: Remove SD_PREFER_LOCAL leftover
Git-Commit-ID: c7660994ed6b44d17dad0aac0d156da1e0a2f003
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Aug 2012 04:29:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7660994ed6b44d17dad0aac0d156da1e0a2f003
Gitweb:     http://git.kernel.org/tip/c7660994ed6b44d17dad0aac0d156da1e0a2f003
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Wed, 15 Aug 2012 08:14:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Aug 2012 13:22:55 +0200

tile: Remove SD_PREFER_LOCAL leftover

commit (sched: recover SD_WAKE_AFFINE in select_task_rq_fair and code
clean up) removed SD_PREFER_LOCAL, but left a SD_PREFER_LOCAL usage in
arch/tile code. That breaks the arch/tile build.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/502AF3E6.3050709@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/include/asm/topology.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index 7a7ce39..d5e86c9 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -69,7 +69,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
