Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1DJRqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 13:46:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10499 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1DJRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 13:46:31 -0400
Date: Sun, 10 Apr 2011 19:46:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trivial@kernel.org
Subject: [PATCH][Trivial] perf: Only include annotate.h once in
 tools/perf/util/ui/browsers/annotate.c
Message-ID: <alpine.LNX.2.00.1104101944070.17706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including "../../annotate.h" once in 
tools/perf/util/ui/browsers/annotate.c is enough. No need to do it twice.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 annotate.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 8c17a87..c1360f7 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -5,7 +5,6 @@
 #include "../../hist.h"
 #include "../../sort.h"
 #include "../../symbol.h"
-#include "../../annotate.h"
 #include <pthread.h>
 
 static void ui__error_window(const char *fmt, ...)


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

