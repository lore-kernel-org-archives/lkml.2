Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2D2GpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:45:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2D2GpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:45:22 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 06/14] watchdog,sysctl: remove unused external
Date: Sun, 29 Apr 2012 08:45:29 +0200
Message-Id: <1335681937-3715-6-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/sched.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9509d80..22e3768 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -312,9 +312,6 @@ extern void sched_show_task(struct task_struct *p);
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
 #else
-- 
1.7.8.5

