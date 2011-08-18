Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1HRQub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:50:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1HRQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:50:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Geunsik Lim <geunsik.lim@samsung.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Kosina <trivial@kernel.org>,
        Joe Perches <joe@perches.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] MAINTAINERS: Fix list of perf events source files
Date: Thu, 18 Aug 2011 13:50:03 -0300
Message-Id: <1313686204-30295-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313686204-30295-1-git-send-email-acme@infradead.org>
References: <1313686204-30295-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Recent changes made kernel/perf_event.c be split and moved to
kernel/events/.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1313653497-27263-1-git-send-email-leemgs1@gmail.com
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e55e1e..7110675 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4971,7 +4971,7 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Supported
-F:	kernel/perf_event*.c
+F:	kernel/events/*
 F:	include/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
-- 
1.6.2.5

