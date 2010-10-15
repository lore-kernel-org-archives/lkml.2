Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0JOTzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:55:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57086 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0JOTzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xQxJBe5mX98qzEK7AXW5vuCOolr7GoOYiMs2vBOch+aEo6FYzdOaRirNoMt3h80aIk
         fC++PrSc+scGITrGfz+oNHaUtA7tG5AbcWW26ZFyZ8N4Ln4zJHBTZG/WnPqHeJe41jeh
         jaPBtWhCMNkk6Fq5c1hu6sowhwv9i2m28OqMI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] kernel: trace: trace_kprobe.c: removed duplicated #include
Date: Fri, 15 Oct 2010 21:27:21 +0200
Message-Id: <1287170842-20279-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.1.181.g784b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed linux/uaccess.h

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 kernel/trace/trace_kprobe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 544301d..c5fb747 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/uaccess.h>
 #include <linux/kprobes.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -479,7 +478,7 @@ struct probe_arg {
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
-	unsigned long 		nhit;
+	unsigned long		nhit;
 	unsigned int		flags;	/* For TP_FLAG_* */
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
-- 
1.7.3.1.181.g784b8

