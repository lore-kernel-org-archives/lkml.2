Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1BDM6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:58:54 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40892 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1BDM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:58:51 -0500
X-AuditID: b753bd60-a32b8ba000004916-5b-4d4bf8096b59
X-AuditID: b753bd60-a32b8ba000004916-5b-4d4bf8096b59
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 2/4] tracing/kprobes: support longer(>128)
	command
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 04 Feb 2011 21:51:59 +0900
Message-ID: <20110204125159.9507.20895.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand command line buffer of kprobe-tracer to 4096 bytes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2088893..c6ed886 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1129,7 +1129,7 @@ static int command_trace_probe(const char *buf)
 	return ret;
 }
 
-#define WRITE_BUFSIZE 128
+#define WRITE_BUFSIZE 4096
 
 static ssize_t probes_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)

