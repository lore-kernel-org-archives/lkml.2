Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966348Ab0CPOqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:44474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966333Ab0CPOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:46:32 -0400
Date: Tue, 16 Mar 2010 14:45:55 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268705556.3379.8.camel@minggr.sh.intel.com>
References: <1268705556.3379.8.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Fix comments in Pentium-4 PMU definitions
Message-ID: <tip-8ea7f544100844307072cae2f5fc108afdef999a@git.kernel.org>
Git-Commit-ID: 8ea7f544100844307072cae2f5fc108afdef999a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:45:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ea7f544100844307072cae2f5fc108afdef999a
Gitweb:     http://git.kernel.org/tip/8ea7f544100844307072cae2f5fc108afdef999a
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Tue, 16 Mar 2010 10:12:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 09:37:46 +0100

x86, perf: Fix comments in Pentium-4 PMU definitions

Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1268705556.3379.8.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index b47b9e9..b842b32 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -319,6 +319,7 @@ static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
 
 #define P4_BSQ_ACTIVE_ENTRIES		P4_EVENT_PACK(0x06, 0x07)
 	/*
+	 * NOTE: no ESCR name in docs, it's guessed
 	 * MSR_P4_BSU_ESCR1:	2, 3
 	 */
 
@@ -468,8 +469,8 @@ static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
 
 #define P4_UOPS_RETIRED			P4_EVENT_PACK(0x01, 0x04)
 	/*
-	 * MSR_P4_CRU_ESCR2:	12, 13, 16
-	 * MSR_P4_CRU_ESCR3:	14, 15, 17
+	 * MSR_P4_CRU_ESCR0:	12, 13, 16
+	 * MSR_P4_CRU_ESCR1:	14, 15, 17
 	 */
 
 #define P4_UOP_TYPE			P4_EVENT_PACK(0x02, 0x02)
