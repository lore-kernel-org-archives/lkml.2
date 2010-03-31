Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0CaSdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:33:35 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:38516 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab0CaSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:33:33 -0400
Date: Wed, 31 Mar 2010 11:30:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf bench: fix spello
Message-Id: <20100331113056.2c7df509.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4BB3952C.027E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix spello in user message.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/bench/sched-pipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-rc3.orig/tools/perf/bench/sched-pipe.c
+++ lnx-2634-rc3/tools/perf/bench/sched-pipe.c
@@ -93,7 +93,7 @@ int bench_sched_pipe(int argc, const cha
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		printf("# Extecuted %d pipe operations between two tasks\n\n",
+		printf("# Executed %d pipe operations between two tasks\n\n",
 			loops);
 
 		result_usec = diff.tv_sec * 1000000;
