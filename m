Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0JWTn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:43:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0JWTn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:43:57 -0400
Date: Sat, 23 Oct 2010 19:43:33 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        trivial@kernel.org, joe@perches.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, joe@perches.com, trivial@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <cd9855af60d7d90e9f55fc7afd0ed23fcdaa6f52.1287724261.git.joe@perches.com>
References: <cd9855af60d7d90e9f55fc7afd0ed23fcdaa6f52.1287724261.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix 'faild' -> 'failed' typo
Message-ID: <tip-aa7b250c252cc8e6b1daf0e1eada5eba42a1a68d@git.kernel.org>
Git-Commit-ID: aa7b250c252cc8e6b1daf0e1eada5eba42a1a68d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:43:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa7b250c252cc8e6b1daf0e1eada5eba42a1a68d
Gitweb:     http://git.kernel.org/tip/aa7b250c252cc8e6b1daf0e1eada5eba42a1a68d
Author:     Joe Perches <joe@perches.com>
AuthorDate: Thu, 21 Oct 2010 22:17:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 Oct 2010 20:06:38 +0200

tracing: Fix 'faild' -> 'failed' typo

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>
LKML-Reference: <cd9855af60d7d90e9f55fc7afd0ed23fcdaa6f52.1287724261.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 544301d..b8d2852 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -648,7 +648,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	}
 	ret = register_probe_event(tp);
 	if (ret) {
-		pr_warning("Faild to register probe event(%d)\n", ret);
+		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
