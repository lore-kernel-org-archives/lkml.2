Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2GVMPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 08:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2GVMPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 08:15:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/17] perf, tool: Adding PERF_ATTR_SIZE_VER2 to the header swap check
Date: Sun, 22 Jul 2012 14:14:31 +0200
Message-Id: <1342959280-5361-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
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
index 5a47aba..9678af6 100644
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

