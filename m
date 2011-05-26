Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1EZI2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:28:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25991 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1EZI2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:28:47 -0400
Date: Thu, 26 May 2011 10:21:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trivial@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][Trivial] perf: remove duplicate util/parse-options.h include
 from builtin-script.c
Message-ID: <alpine.LNX.2.00.1105261011290.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including util/parse-options.h once in tools/perf/builtin-script.c is 
enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 builtin-script.c |    1 -
 1 file changed, 1 deletion(-)

 Patch is against Linus' tree as of a few minutes ago.

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 974f6d3..22747de 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -10,7 +10,6 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/parse-options.h"
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

