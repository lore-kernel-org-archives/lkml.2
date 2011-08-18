Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1HRCIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:08:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:37840 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1HRCIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:08:20 -0400
From: Geunsik Lim <leemgs1@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joe Perches <joe@perches.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] file info modification to maintain perf
Date: Thu, 18 Aug 2011 11:08:09 +0900
Message-Id: <1313633289-11410-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Actually, perf related c sources depends on architecture core.
So,'./kernel/perf_event.c'file still not exist from the latest
linux version.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d445f5..7ae72d49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4971,7 +4971,6 @@ M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Supported
-F:	kernel/perf_event*.c
 F:	include/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
-- 
1.7.3.4

