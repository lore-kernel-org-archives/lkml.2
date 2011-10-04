Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1JDKmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:42:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37464 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1JDKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:42:49 -0400
X-AuditID: b753bd60-a2688ba000000655-a1-4e8ae32700f2
X-AuditID: b753bd60-a2688ba000000655-a1-4e8ae32700f2
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 2/4] [TRIVIAL] ftrace/kprobes: Fix an warning typo
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 04 Oct 2011 19:44:49 +0900
Message-ID: <20111004104449.14591.16995.stgit@fedora15>
In-Reply-To: <20111004104438.14591.6553.stgit@fedora15>
References: <20111004104438.14591.6553.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a space between words.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---

 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 00d527c..5763546 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -806,7 +806,7 @@ static int __register_trace_probe(struct trace_probe *tp)
 		pr_warning("Could not insert probe at %s+%lu: %d\n",
 			   trace_probe_symbol(tp), trace_probe_offset(tp), ret);
 		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
-			pr_warning("This probe might be able to register after"
+			pr_warning("This probe might be able to register after "
 				   "target module is loaded. Continue.\n");
 			ret = 0;
 		} else if (ret == -EILSEQ) {

