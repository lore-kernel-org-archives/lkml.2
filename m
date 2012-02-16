Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2BPNyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:54:41 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51358 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab2BPNyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:54:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Danny Kukawka <dkukawka@suse.de>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jovi Zhang <bookjovi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools/perf/util/probe-event.c included string.h twice
Date: Thu, 16 Feb 2012 14:54:19 +0100
Message-Id: <1329400459-31570-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400479;b4262c5d;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tools/perf/util/probe-event.c included 'string.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 tools/perf/util/probe-event.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..8ce8356 100644
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
1.7.8.3

