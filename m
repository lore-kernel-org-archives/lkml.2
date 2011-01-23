Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1AWSCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:02:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:55978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1AWSCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:02:16 -0500
Date: Sun, 23 Jan 2011 18:01:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        eric.dumazet@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Add missing header, fixes build
Message-ID: <tip-a860a60818e48134c60315bf32f87575771e6602@git.kernel.org>
Git-Commit-ID: a860a60818e48134c60315bf32f87575771e6602
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 Jan 2011 18:01:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a860a60818e48134c60315bf32f87575771e6602
Gitweb:     http://git.kernel.org/tip/a860a60818e48134c60315bf32f87575771e6602
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 22 Jan 2011 19:07:36 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:15:39 -0200

perf tools: Add missing header, fixes build

We need the definiton for __always_inline in bitops.h to fix the build
on distros where it isn't available or compiler.h doesn't get included
indirectly.

One of the fixes needed to build perf on RHEL4 systems, for instance.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 8be0b96..305c848 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -2,6 +2,7 @@
 #define _PERF_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <asm/hweight.h>
 
 #define BITS_PER_LONG __WORDSIZE
