Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871Ab0GOWHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:07:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848Ab0GOWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=awqos8Hm3Xl5ohGO62XfKHyY8OpXgvoNgREBnmOf0Lz/rxniTbvIy2ogKxg7pq7bBB
         be1D8OGXYfw30mpUHvUa6u0alflb4q3vEdMeZKQy/IcUtNwTnMN7HWimFWhJzI5nC0lo
         VQfgvTmAWdjqrLVgpWsKyeHs5A73EXjQuYQyE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/3] tracing: Remove letfover markers section
Date: Fri, 16 Jul 2010 00:06:43 +0200
Message-Id: <1279231603-30624-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
References: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markers have been removed, but we forgot to remove their
section.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/asm-generic/vmlinux.lds.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..415b1a9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -150,10 +150,6 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
-	. = ALIGN(8);							\
-	VMLINUX_SYMBOL(__start___markers) = .;				\
-	*(__markers)							\
-	VMLINUX_SYMBOL(__stop___markers) = .;				\
 	. = ALIGN(32);							\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
-- 
1.6.2.3

