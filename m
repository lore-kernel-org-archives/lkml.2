Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2BNByT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2BNBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/16] perf tools: Fix out of tree compiles
Date: Mon, 13 Feb 2012 23:52:43 -0200
Message-Id: <1329184375-27911-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.7.9.123.g65da0

