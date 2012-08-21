Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2HUPvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:51:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2HUPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:51:41 -0400
Date: Tue, 21 Aug 2012 08:51:10 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-239cc47819ec5e1acde42d416755c332ed5cf2c8@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-8-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Adding PERF_ATTR_SIZE_VER2 to the header swap check
Git-Commit-ID: 239cc47819ec5e1acde42d416755c332ed5cf2c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:51:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  239cc47819ec5e1acde42d416755c332ed5cf2c8
Gitweb:     http://git.kernel.org/tip/239cc47819ec5e1acde42d416755c332ed5cf2c8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:42 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 16:32:03 -0300

perf tools: Adding PERF_ATTR_SIZE_VER2 to the header swap check

Updating attr_file_abi_sizes array with PERF_ATTR_SIZE_VER2 version, so
we have the swap check complete.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b2da439..dd5a53c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1829,6 +1829,7 @@ out_free:
 static const int attr_file_abi_sizes[] = {
 	[0] = PERF_ATTR_SIZE_VER0,
 	[1] = PERF_ATTR_SIZE_VER1,
+	[2] = PERF_ATTR_SIZE_VER2,
 	0,
 };
 
