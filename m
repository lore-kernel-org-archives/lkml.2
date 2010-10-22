Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0JVFRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:17:32 -0400
Received: from mail.perches.com ([173.55.12.10]:3489 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0JVFR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:29 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] kernel/trace: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:19 -0700
Message-Id: <cd9855af60d7d90e9f55fc7afd0ed23fcdaa6f52.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
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
 
-- 
1.7.3.1.g432b3.dirty

