Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2AHLvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:51:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2AHLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:51:16 -0500
Date: Sun, 8 Jan 2012 03:50:23 -0800
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-cc5a91e972212aea022ff86b2c11d3e84d552bf5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, sebastian@breakpoint.cc, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, sebastian@breakpoint.cc, mingo@elte.hu
In-Reply-To: <1324128938-17553-1-git-send-email-sebastian@breakpoint.cc>
References: <1324128938-17553-1-git-send-email-sebastian@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add const.
 h to MANIFEST to make perf-tar-src-pkg work again
Git-Commit-ID: cc5a91e972212aea022ff86b2c11d3e84d552bf5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:50:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc5a91e972212aea022ff86b2c11d3e84d552bf5
Gitweb:     http://git.kernel.org/tip/cc5a91e972212aea022ff86b2c11d3e84d552bf5
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Sat, 17 Dec 2011 14:35:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Jan 2012 15:52:18 -0200

perf tools: Add const.h to MANIFEST to make perf-tar-src-pkg work again

Fixes:
|make: *** No rule to make target `../../include/linux/const.h', needed by `builtin-annotate.o'.  Stop.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324128938-17553-1-git-send-email-sebastian@breakpoint.cc
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c12659d..1078c5f 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,4 +1,5 @@
 tools/perf
+include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
 include/linux/list.h
