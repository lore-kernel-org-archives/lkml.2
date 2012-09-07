Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2IGF4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:56:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2IGFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:55:58 -0400
Date: Thu, 6 Sep 2012 22:55:17 -0700
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-ff1a70e75fd005821ab5f2211312a8aa13bbf959@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1345735321.5069.62.camel@gandalf.local.home>
References: <1345735321.5069.62.camel@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Modify header to work in C++ programs
Git-Commit-ID: ff1a70e75fd005821ab5f2211312a8aa13bbf959
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 22:55:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff1a70e75fd005821ab5f2211312a8aa13bbf959
Gitweb:     http://git.kernel.org/tip/ff1a70e75fd005821ab5f2211312a8aa13bbf959
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Thu, 23 Aug 2012 11:22:01 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:17:30 -0300

tools lib traceevent: Modify header to work in C++ programs

Replace keyword "private" to "priv" in event-parse.h to allow it to be
used in C++ programs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345735321.5069.62.camel@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 527df03..863a0bb 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -49,7 +49,7 @@ struct pevent_record {
 	int			cpu;
 	int			ref_count;
 	int			locked;		/* Do not free, even if ref_count is zero */
-	void			*private;
+	void			*priv;
 #if DEBUG_RECORD
 	struct pevent_record	*prev;
 	struct pevent_record	*next;
@@ -106,7 +106,7 @@ struct plugin_option {
 	char				*plugin_alias;
 	char				*description;
 	char				*value;
-	void				*private;
+	void				*priv;
 	int				set;
 };
 
