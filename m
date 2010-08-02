Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0HBHwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0HBHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:52:29 -0400
Date: Mon, 2 Aug 2010 07:51:43 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf man pages: Fix cut'n'paste error
Message-ID: <tip-8c31a1e049a0c26f78558d7cc5a9ab6956c86694@git.kernel.org>
Git-Commit-ID: 8c31a1e049a0c26f78558d7cc5a9ab6956c86694
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c31a1e049a0c26f78558d7cc5a9ab6956c86694
Gitweb:     http://git.kernel.org/tip/8c31a1e049a0c26f78558d7cc5a9ab6956c86694
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 28 Jul 2010 11:30:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 28 Jul 2010 11:30:10 -0300

perf man pages: Fix cut'n'paste error

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
