Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1J1Nrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:47:52 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42980 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1J1Nrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:47:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] CPU hotplug, PM: Remove unused symbol 'suspend_cpu_hotplug'
To: rjw@sisk.pl
Cc: stern@rowland.harvard.edu, akpm@linux-foundation.org, gregkh@suse.de,
        brandon@ifup.org, amwang@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, a.p.zijlstra@chello.nl, pavel@ucw.cz,
        linux-pm@lists.linux-foundation.org, mingo@elte.hu
Date: Fri, 28 Oct 2011 19:17:40 +0530
Message-ID: <20111028134737.18461.60249.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index b1a635a..6cb60fd 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -196,13 +196,9 @@ static inline void cpu_hotplug_driver_unlock(void)
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_PM_SLEEP_SMP
-extern int suspend_cpu_hotplug;
-
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
 #else /* !CONFIG_PM_SLEEP_SMP */
-#define suspend_cpu_hotplug	0
-
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */

