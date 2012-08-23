Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2HWPWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:22:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2HWPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:22:02 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FsujGz5P2AAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=UEj97x6e2yEA:10 a=meVymXHHAAAA:8 a=NSdFalvNd4hVpqyf3GoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345735321.5069.62.camel@gandalf.local.home>
Subject: [PATCH v2] tools lib traceevent: Modify header to work in C++
 programs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 23 Aug 2012 11:22:01 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace keyword "private" to "priv" in event-parse.h to allow it to be
used in C++ programs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5772ad8..720ad63 100644
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
 
-- 
1.7.3.4



