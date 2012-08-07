Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2HGNYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2HGNWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:22:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/12] perf tools: Adding PERF_ATTR_SIZE_VER2 to the header swap check
Date: Tue,  7 Aug 2012 15:20:42 +0200
Message-Id: <1344345647-11536-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1344345647-11536-1-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating attr_file_abi_sizes array with PERF_ATTR_SIZE_VER2 version,
so we have the swap check complete.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
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
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/header.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 74ea3c2..db91425 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1829,6 +1829,7 @@ out_free:
 static const int attr_file_abi_sizes[] = {
 	[0] = PERF_ATTR_SIZE_VER0,
 	[1] = PERF_ATTR_SIZE_VER1,
+	[2] = PERF_ATTR_SIZE_VER2,
 	0,
 };
 
-- 
1.7.11.2

