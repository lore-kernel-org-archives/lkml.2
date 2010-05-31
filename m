Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0EaIB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:33307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab0EaIBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:01:24 -0400
Date: Mon, 31 May 2010 08:00:41 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       randy.dunlap@oracle.com, jens.axboe@oracle.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, jens.axboe@oracle.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100529114507.c466fc1e.randy.dunlap@oracle.com>
References: <20100529114507.c466fc1e.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] blktrace: Fix new kernel-doc warnings
Message-ID: <tip-546cf44a1b507c1cbb5cf42bbe6169780567f36f@git.kernel.org>
Git-Commit-ID: 546cf44a1b507c1cbb5cf42bbe6169780567f36f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 08:00:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  546cf44a1b507c1cbb5cf42bbe6169780567f36f
Gitweb:     http://git.kernel.org/tip/546cf44a1b507c1cbb5cf42bbe6169780567f36f
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sat, 29 May 2010 11:45:07 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 09:58:20 +0200

blktrace: Fix new kernel-doc warnings

Fix blktrace.c kernel-doc warnings:
 Warning(kernel/trace/blktrace.c:858): No description found for parameter 'ignore'
 Warning(kernel/trace/blktrace.c:890): No description found for parameter 'ignore'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100529114507.c466fc1e.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/blktrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 36ea2b6..638711c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -842,6 +842,7 @@ static void blk_add_trace_split(void *ignore,
 
 /**
  * blk_add_trace_remap - Add a trace for a remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
@@ -873,6 +874,7 @@ static void blk_add_trace_remap(void *ignore,
 
 /**
  * blk_add_trace_rq_remap - Add a trace for a request-remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @rq:		the source request
  * @dev:	target device
