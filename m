Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1FAR7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:59:24 -0400
Received: from mail.perches.com ([173.55.12.10]:2380 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab1FAR7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:21 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 4/6] MAINTAINERS: Remove unused PERFORMANCE EVENTS pattern
Date: Wed,  1 Jun 2011 10:59:12 -0700
Message-Id: <8d1e596980a6b6fec79432bb5a5953985cf85c2f.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No arch/*/lib/perf_event* files exist so remove the pattern.

cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Paul Mackerras <paulus@samba.org>
cc: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab6340f..6f6a8ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4908,7 +4908,6 @@ F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
-- 
1.7.5.rc3.dirty

