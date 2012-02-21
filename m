Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2BURf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:35:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:41222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2BURfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:35:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Danny Kukawka <danny.kukawka@bisect.de>,
        Danny Kukawka <dkukawka@suse.de>, Jovi Zhang <bookjovi@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf tools: Remove duplicated string.h includes
Date: Tue, 21 Feb 2012 15:35:26 -0200
Message-Id: <1329845727-21512-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329845727-21512-1-git-send-email-acme@infradead.org>
References: <1329845727-21512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>

tools/perf/util/probe-event.c included 'string.h' twice, remove the
duplicate.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Danny Kukawka <dkukawka@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jovi Zhang <bookjovi@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1329400459-31570-1-git-send-email-danny.kukawka@bisect.de
Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c1a513e..8379252 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -34,7 +34,6 @@
 
 #include "util.h"
 #include "event.h"
-#include "string.h"
 #include "strlist.h"
 #include "debug.h"
 #include "cache.h"
-- 
1.7.9.123.g65da0

