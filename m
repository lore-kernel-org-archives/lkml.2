Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2GZPOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:14:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2GZPOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:14:09 -0400
Date: Thu, 26 Jul 2012 08:13:45 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2jxkmktkppkclj1qe6qxd7ah@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, fengguang.wu@intel.com,
        bp@amd64.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, bp@amd64.org,
        fengguang.wu@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Make bitfield unsigned
Git-Commit-ID: 597ed953d7db28528b4687e46388c1aa905c14bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:13:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  597ed953d7db28528b4687e46388c1aa905c14bd
Gitweb:     http://git.kernel.org/tip/597ed953d7db28528b4687e46388c1aa905c14bd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 9 Jul 2012 13:50:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 12:23:13 +0200

perf/x86: Make bitfield unsigned

Fix:

 arch/x86/kernel/cpu/perf_event.h:377:43: sparse: dubious one-bit signed bitfield

Cc: Borislav Petkov <bp@amd64.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2jxkmktkppkclj1qe6qxd7ah@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index a15df4b..821d53b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -374,7 +374,7 @@ struct x86_pmu {
 	/*
 	 * Intel DebugStore bits
 	 */
-	int		bts		:1,
+	unsigned int	bts		:1,
 			bts_active	:1,
 			pebs		:1,
 			pebs_active	:1,
