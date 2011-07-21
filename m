Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1GUTcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:32:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:50379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1GUTca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:32:30 -0400
Date: Thu, 21 Jul 2011 19:32:10 GMT
From: tip-bot for Will Deacon <will.deacon@arm.com>
Message-ID: <tip-7fcfd1abd6480d3b9ef17f5759c175e036e835cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110708173442.GB31972@e102144-lin.cambridge.arm.com>
References: <20110708173442.GB31972@e102144-lin.cambridge.arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove the nmi parameter from the oprofile_perf backend
Git-Commit-ID: 7fcfd1abd6480d3b9ef17f5759c175e036e835cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 19:32:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fcfd1abd6480d3b9ef17f5759c175e036e835cf
Gitweb:     http://git.kernel.org/tip/7fcfd1abd6480d3b9ef17f5759c175e036e835cf
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Fri, 8 Jul 2011 18:34:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 20:41:58 +0200

perf: Remove the nmi parameter from the oprofile_perf backend

In commit a8b0ca17b80e ("perf: Remove the nmi parameter from the
swevent and overflow interface") one site was overlooked.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110708173442.GB31972@e102144-lin.cambridge.arm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/oprofile/oprofile_perf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 59acf9e..94796f3 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -31,7 +31,7 @@ static int num_counters;
 /*
  * Overflow callback for oprofile.
  */
-static void op_overflow_handler(struct perf_event *event, int unused,
+static void op_overflow_handler(struct perf_event *event,
 			struct perf_sample_data *data, struct pt_regs *regs)
 {
 	int id;
