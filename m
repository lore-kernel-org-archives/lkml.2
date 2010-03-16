Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937392Ab0CPCbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:31:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:63936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0CPCbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:31:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="500915576"
Subject: [PATCH] x86,perf: fix comments in p4 pmu definitions
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Mar 2010 10:12:36 +0800
Message-Id: <1268705556.3379.8.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
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


