Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2JHWdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:33:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2JHWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/25] perf tools: Remove duplicated include from trace-event-python.c
Date: Mon,  8 Oct 2012 19:32:43 -0300
Message-Id: <1349735570-19339-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Link: http://lkml.kernel.org/r/CAPgLHd8fz+TznMVRdhzPb45WtZQXhVxadRQcLxUC4O9aX+SUbA@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    |    1 -
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
 
-- 
1.7.9.2.358.g22243

