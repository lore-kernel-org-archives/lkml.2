Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1GEM5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:57:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:59529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab1GEM5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:57:12 -0400
Date: Tue, 5 Jul 2011 12:56:59 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Message-ID: <tip-8edbb83e5bc3c7d5d76861fc61872105288d2610@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        xiyou.wangcong@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        xiyou.wangcong@gmail.com, mingo@elte.hu
In-Reply-To: <20110705133240.25e81a7a@kryten>
References: <20110705133240.25e81a7a@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockup detector: Fix reference to the non-existent CONFIG_DETECT_SOFTLOCKUP option
Git-Commit-ID: 8edbb83e5bc3c7d5d76861fc61872105288d2610
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:56:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8edbb83e5bc3c7d5d76861fc61872105288d2610
Gitweb:     http://git.kernel.org/tip/8edbb83e5bc3c7d5d76861fc61872105288d2610
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 5 Jul 2011 13:32:40 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 Jul 2011 13:00:23 +0200

lockup detector: Fix reference to the non-existent CONFIG_DETECT_SOFTLOCKUP option

Replace CONFIG_DETECT_SOFTLOCKUP with CONFIG_LOCKUP_DETECTOR.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: fweisbec@gmail.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/20110705133240.25e81a7a@kryten
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..9c28fa4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -227,7 +227,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
-	default DETECT_SOFTLOCKUP
+	default LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to detect "hung tasks",
 	  which are bugs that cause the task to be stuck in
@@ -866,7 +866,7 @@ config BOOT_PRINTK_DELAY
 	  system, and then set "lpj=M" before setting "boot_delay=N".
 	  NOTE:  Using this option may adversely affect SMP systems.
 	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
 config RCU_TORTURE_TEST
