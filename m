Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2FSPtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab2FSPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/23] perf, tool: Adding PERF_ATTR_SIZE_VER2 to the header swap check
Date: Tue, 19 Jun 2012 17:48:01 +0200
Message-Id: <1340120894-9465-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating attr_file_abi_sizes array with PERF_ATTR_SIZE_VER2 version,
so we have the swap check complete.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/header.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e909d43..997b075 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1814,6 +1814,7 @@ out_free:
 static const int attr_file_abi_sizes[] = {
 	[0] = PERF_ATTR_SIZE_VER0,
 	[1] = PERF_ATTR_SIZE_VER1,
+	[2] = PERF_ATTR_SIZE_VER2,
 	0,
 };
 
-- 
1.7.7.6

