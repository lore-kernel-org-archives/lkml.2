Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2BVQD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:03:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2BVQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:03:55 -0500
Date: Wed, 22 Feb 2012 08:02:28 -0800
From: tip-bot for Danny Kukawka <danny.kukawka@bisect.de>
Message-ID: <tip-dfd3b1e3e8a580bcbf854d46ae0f22c8333e82d8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        danny.kukawka@bisect.de, bookjovi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dkukawka@suse.de, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        danny.kukawka@bisect.de, bookjovi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dkukawka@suse.de, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1329400459-31570-1-git-send-email-danny.kukawka@bisect.de>
References: <1329400459-31570-1-git-send-email-danny.kukawka@bisect.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove duplicated string.h includes
Git-Commit-ID: dfd3b1e3e8a580bcbf854d46ae0f22c8333e82d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:03:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfd3b1e3e8a580bcbf854d46ae0f22c8333e82d8
Gitweb:     http://git.kernel.org/tip/dfd3b1e3e8a580bcbf854d46ae0f22c8333e82d8
Author:     Danny Kukawka <danny.kukawka@bisect.de>
AuthorDate: Thu, 16 Feb 2012 14:54:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Feb 2012 16:34:09 -0200

perf tools: Remove duplicated string.h includes

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
