Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2H0Q7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:59:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2H0Q7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:59:03 -0400
Date: Mon, 27 Aug 2012 09:57:58 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-1659d129ed014b715b0b2120e6fd929bdd33ed03@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20120822083540.GB1003@krava.brq.redhat.com>
References: <20120822083540.GB1003@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Keep the perf_event_attr on version 3
Git-Commit-ID: 1659d129ed014b715b0b2120e6fd929bdd33ed03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:58:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1659d129ed014b715b0b2120e6fd929bdd33ed03
Gitweb:     http://git.kernel.org/tip/1659d129ed014b715b0b2120e6fd929bdd33ed03
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 22 Aug 2012 10:35:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 15:33:12 -0300

perf tools: Keep the perf_event_attr on version 3

Stashing version 4 under version 3 and removing version 4, because both
version changes were within single patchset.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/20120822083540.GB1003@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    4 ++--
 tools/perf/util/header.c   |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 297ca3d..28f9cee 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -205,8 +205,8 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
 #define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
-#define PERF_ATTR_SIZE_VER3	88	/* add: sample_regs_user */
-#define PERF_ATTR_SIZE_VER4	96	/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
+					/* add: sample_stack_user */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 63aad31..9696e64 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2011,7 +2011,6 @@ static const int attr_file_abi_sizes[] = {
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
 	[3] = PERF_ATTR_SIZE_VER3,
-	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
