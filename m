Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1HIMrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1HIMrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:47:05 -0400
Date: Tue, 9 Aug 2011 14:46:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf, sched: Usage leftover from trace -> script rename
Message-ID: <20110809124651.GD2056@jolsa.brq.redhat.com>
References: <1312837414-3819-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312837414-3819-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and this oneline change depending on the previous one ;)

thanks,
jirka

---
The 'perf sched' command usage still showing 'trace'
command instead of the 'script' command.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3d5702c..5177964 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1777,7 +1777,7 @@ static void __cmd_replay(void)
 
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|map|replay|trace}",
+	"perf sched [<options>] {record|latency|map|replay|script}",
 	NULL
 };
 
-- 
1.7.1

