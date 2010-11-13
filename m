Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0KMWqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:46:18 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29051 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0KMWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:46:17 -0500
Date: Sat, 13 Nov 2010 23:34:12 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] tools/perf/builtin-trace.c includes util/parse-options.h
 twice.
Message-ID: <alpine.LNX.2.00.1011132331560.19666@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This removes the duplicate inclusion of util/parse-options.h from 
tools/perf/builtin-trace.c


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 builtin-trace.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 86cfe38..a4509de 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
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

