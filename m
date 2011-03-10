Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1CJP7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1CJP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:13 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=iGZYW5WSfGcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=WIM9DRW691BOJGnlR6EA:9 a=KUPWeXxgSC_v7B5GId4G7iSC40gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155912.592150020@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 14/15] tracing: Align 4 byte ints together in struct tracer
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Align-4-byte-ints-together-in-struct-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Move elements in struct tracer for better alignment.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 951d0b7..5e9dfc6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -272,8 +272,8 @@ struct tracer {
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
 	struct tracer		*next;
-	int			print_max;
 	struct tracer_flags	*flags;
+	int			print_max;
 	int			use_max_tr;
 };
 
-- 
1.7.2.3


