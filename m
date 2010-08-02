Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0HBBMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:12:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0HBBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/19] perf man pages: Fix cut'n'paste error
Date: Sun,  1 Aug 2010 22:08:45 -0300
Message-Id: <1280711334-30000-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We remove files _from_ the cache.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index 5d1a950..c105770 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command manages the build-id cache. It can add and remove files to the
-cache. In the future it should as well purge older entries, set upper limits
-for the space used by the cache, etc.
+This command manages the build-id cache. It can add and remove files to/from
+the cache. In the future it should as well purge older entries, set upper
+limits for the space used by the cache, etc.
 
 OPTIONS
 -------
@@ -23,7 +23,7 @@ OPTIONS
         Add specified file to the cache.
 -r::
 --remove=::
-        Remove specified file to the cache.
+        Remove specified file from the cache.
 -v::
 --verbose::
 	Be more verbose.
-- 
1.6.2.5

