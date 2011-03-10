Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1CJP7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1CJP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:15 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=U_kwPE2YPCQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=wyuh3eUqkQ_FVZpSK7gA:9 a=Mysdrq29yNle8IO9BnyYSe8XJ4wA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155909.430836352@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 02/15] ring-buffer: Remove unused #include <linux/trace_irq.h>
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Remove-unused-include-linux-trace_irq.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-3-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 269db80..3237d96 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5,7 +5,6 @@
  */
 #include <linux/ring_buffer.h>
 #include <linux/trace_clock.h>
-#include <linux/ftrace_irq.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
-- 
1.7.2.3


