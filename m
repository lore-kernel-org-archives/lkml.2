Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1HLFaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:30:35 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44259 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1HLFad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:30:33 -0400
From: Geunsik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: tracing_on to start/stop tracing
Date: Fri, 12 Aug 2011 14:30:22 +0900
Message-Id: <1313127022-23830-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

tracing_enabled option is deprecated.
To start/stop tracing, write to /sys/kernel/debug/tracing/tracing_on
without tracing_enabled. This patch is based on Linux 3.1.0-rc1

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..91abdbf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2710,9 +2710,9 @@ static const char readme_msg[] =
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
 	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
 ;
 
 static ssize_t
-- 
1.7.3.4

