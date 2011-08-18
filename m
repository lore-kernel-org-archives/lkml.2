Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1HRHpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:45:13 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:39234 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1HRHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:45:07 -0400
From: Geunsik Lim <leemgs1@gmail.com>
To: Jiri Kosina <trivial@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joe Perches <joe@perches.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] MAINTAINER:file info modification to maintain perf
Date: Thu, 18 Aug 2011 16:44:57 +0900
Message-Id: <1313653497-27263-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Actually, perf related c sources depends on architecture core.
So, ./kernel/perf_event.c file not exist from the latest
linux version. Append kernel/events/* content that means
performance events code.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
CC:Li Zefan <lizf@cn.fujitsu.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d445f5..069ee3b 100644
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
1.7.3.4

