Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1EZIeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:34:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:59529 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1EZIeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:34:15 -0400
Date: Thu, 26 May 2011 10:26:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][Trivial] perf: remove duplicate util/util.h include from
 builtin-annotate.c
Message-ID: <alpine.LNX.2.00.1105261024120.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include util/util.h just once in tools/perf/builtin-annotate.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 builtin-annotate.c |    2 --
 1 file changed, 2 deletions(-)

 Patch against Linus' tree as of a few minutes ago.

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e18eb7e..7b139e1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -8,8 +8,6 @@
 #include "builtin.h"
 
 #include "util/util.h"
-
-#include "util/util.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

