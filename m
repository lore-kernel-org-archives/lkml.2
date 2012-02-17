Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2BQJqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:46:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2BQJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:46:08 -0500
Date: Fri, 17 Feb 2012 01:45:29 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-eca1c3e3f937307331fd1fd5ee5205e57f2131ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1329145057-26302-1-git-send-email-dsahern@gmail.com>
References: <1329145057-26302-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix out of tree compiles
Git-Commit-ID: eca1c3e3f937307331fd1fd5ee5205e57f2131ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:45:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eca1c3e3f937307331fd1fd5ee5205e57f2131ca
Gitweb:     http://git.kernel.org/tip/eca1c3e3f937307331fd1fd5ee5205e57f2131ca
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 13 Feb 2012 07:57:37 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 22:46:41 -0200

perf tools: Fix out of tree compiles

For latest tip/perf/core tree Compiles are failing on:

GEN common-cmds.h
make: *** No rule to make target `../../arch/x86/lib/memset_64.S', needed by `builtin-annotate.o'.  Stop.

Resolve by adding memset.* to the tar file.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1329145057-26302-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 1078c5f..5476bc0 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -9,6 +9,7 @@ lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
 arch/*/lib/memcpy*.S
+arch/*/lib/memset*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
