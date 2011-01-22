Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1AVL3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:29:17 -0500
Received: from gw.loccal.net ([94.142.235.206]:44707 "EHLO mail.loccal.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1AVL3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:29:16 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 06:29:16 EST
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: Document default event for perf record
Date: Sat, 22 Jan 2011 12:18:37 +0100
Message-Id: <1295695127-29309-1-git-send-email-sojkam1@fel.cvut.cz>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description of -e option was reformatted (unindented and enclosed
in an OpenBlock) in order to render the added line correctly.
---
 tools/perf/Documentation/perf-record.txt |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e032716..bfcf3f2 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -27,18 +27,22 @@ OPTIONS
 -e::
 --event=::
 	Select the PMU event. Selection can be:
-
-        - a symbolic event name	(use 'perf list' to list all events)
-
-        - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
-	  hexadecimal event descriptor.
-
-        - a hardware breakpoint event in the form of '\mem:addr[:access]'
-          where addr is the address in memory you want to break in.
-          Access is the memory access type (read, write, execute) it can
-          be passed as follows: '\mem:addr[:[r][w][x]]'.
-          If you want to profile read-write accesses in 0x1000, just set
-          'mem:0x1000:rw'.
++
+--
+- a symbolic event name	(use 'perf list' to list all events)
+
+- a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
+  hexadecimal event descriptor.
+
+- a hardware breakpoint event in the form of '\mem:addr[:access]'
+  where addr is the address in memory you want to break in.
+  Access is the memory access type (read, write, execute) it can
+  be passed as follows: '\mem:addr[:[r][w][x]]'.
+  If you want to profile read-write accesses in 0x1000, just set
+  'mem:0x1000:rw'.
+
+By default, 'cpu-cycles' event is selected.
+--
 
 --filter=<filter>::
         Event filter.
-- 
1.7.2.3

