Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2JGOJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:09:21 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36022 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2JGOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:09:13 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 22:09:12 +0800
Message-ID: <CAPgLHd8fz+TznMVRdhzPb45WtZQXhVxadRQcLxUC4O9aX+SUbA@mail.gmail.com>
Subject: [PATCH] perf tools: remove duplicated include from trace-event-python.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 730c663..14683df 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -32,7 +32,6 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
-#include "../evsel.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 

