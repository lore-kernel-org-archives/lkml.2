Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2IKXxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:53:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2IKXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/18] perf tools: Add missing perf_regs.h file to MANIFEST
Date: Tue, 11 Sep 2012 20:52:57 -0300
Message-Id: <1347407590-30960-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 2bcd355 broke the perf-tar*-src-pkg generated tarballs builds, fix
it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2ndz2o636rn4q175fwn18x32@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index b4b572e..0518079 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -10,6 +10,7 @@ include/linux/stringify.h
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
+arch/*/include/asm/perf_regs.h
 arch/*/lib/memcpy*.S
 arch/*/lib/memset*.S
 include/linux/poison.h
-- 
1.7.9.2.358.g22243

