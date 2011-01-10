Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1AJWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:14:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15733 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1AJWOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:14:20 -0500
Date: Mon, 10 Jan 2011 23:14:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] perf builtin-script: It's enough to include util/parse-options.h
 header once.
Message-ID: <alpine.LNX.2.00.1101102312160.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be enough to include util/parse-options.h once in 
tools/perf/builtin-script.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 builtin-script.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 150a606..0173a80 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -8,11 +8,10 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
-#include "util/parse-options.h"
 #include "util/util.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
 static bool			debug_mode;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

