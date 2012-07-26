Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2GZPLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:11:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2GZPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:11:21 -0400
Date: Thu, 26 Jul 2012 08:11:06 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-4f3f713fc78d966d81ad87d2f3587369f9b34ae6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1343024611-4692-1-git-send-email-zheng.z.yan@intel.com>
References: <1343024611-4692-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix typo in format definition of uncore PCU filter
Git-Commit-ID: 4f3f713fc78d966d81ad87d2f3587369f9b34ae6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:11:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f3f713fc78d966d81ad87d2f3587369f9b34ae6
Gitweb:     http://git.kernel.org/tip/4f3f713fc78d966d81ad87d2f3587369f9b34ae6
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Mon, 23 Jul 2012 14:23:30 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 12:23:11 +0200

perf/x86: Fix typo in format definition of uncore PCU filter

The format definition of uncore PCU filter should be filter_band*
instead of filter_brand*.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1343024611-4692-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 19faffc..a5de59f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -33,10 +33,10 @@ DEFINE_UNCORE_FORMAT_ATTR(filter_tid, filter_tid, "config1:0-4");
 DEFINE_UNCORE_FORMAT_ATTR(filter_nid, filter_nid, "config1:10-17");
 DEFINE_UNCORE_FORMAT_ATTR(filter_state, filter_state, "config1:18-22");
 DEFINE_UNCORE_FORMAT_ATTR(filter_opc, filter_opc, "config1:23-31");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand0, filter_brand0, "config1:0-7");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand1, filter_brand1, "config1:8-15");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand2, filter_brand2, "config1:16-23");
-DEFINE_UNCORE_FORMAT_ATTR(filter_brand3, filter_brand3, "config1:24-31");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band0, filter_band0, "config1:0-7");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band1, filter_band1, "config1:8-15");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band2, filter_band2, "config1:16-23");
+DEFINE_UNCORE_FORMAT_ATTR(filter_band3, filter_band3, "config1:24-31");
 
 /* Sandy Bridge-EP uncore support */
 static struct intel_uncore_type snbep_uncore_cbox;
@@ -272,10 +272,10 @@ static struct attribute *snbep_uncore_pcu_formats_attr[] = {
 	&format_attr_thresh5.attr,
 	&format_attr_occ_invert.attr,
 	&format_attr_occ_edge.attr,
-	&format_attr_filter_brand0.attr,
-	&format_attr_filter_brand1.attr,
-	&format_attr_filter_brand2.attr,
-	&format_attr_filter_brand3.attr,
+	&format_attr_filter_band0.attr,
+	&format_attr_filter_band1.attr,
+	&format_attr_filter_band2.attr,
+	&format_attr_filter_band3.attr,
 	NULL,
 };
 
