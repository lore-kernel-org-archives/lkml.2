Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HKThq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:37:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1HKThp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:37:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=I5Vxdf0GnIrxm92wwh81PNO3eqayRjJMzG+W+DQdrIjY1S0xEVOFtD/1HuiqZDuEl
	efIFrx4Yp/SwwqQl1qJBg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/5] trace-cmd: Add function declaration to fix compile warning
Date: Thu, 11 Aug 2011 12:37:35 -0700
Message-Id: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function trace_util_ftrace_options() is not declared and causes a
compile warning. This patch declares it in trace-cmd.h.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-cmd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index f436845..66cdb28 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -209,6 +209,7 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 /* --- Plugin handling --- */
 extern struct plugin_option trace_ftrace_options[];
 
+void trace_util_ftrace_options(void);
 void trace_util_add_option(const char *name, const char *val);
 void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
 			     void (*load_plugin)(struct pevent *pevent,
-- 
1.7.3.1

