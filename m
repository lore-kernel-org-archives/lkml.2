Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1AXN5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:57:21 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:42599 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1AXN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:57:20 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2011 08:57:19 EST
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: Document default event for perf record
In-Reply-To: <20110124131050.GA6367@ghostprotocols.net>
References: <1295695127-29309-1-git-send-email-sojkam1@fel.cvut.cz> <20110124130540.GD5932@ghostprotocols.net> <20110124131050.GA6367@ghostprotocols.net>
User-Agent: Notmuch/0.5-87-g9705d00 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Jan 2011 14:16:14 +0100
Message-ID: <87aaiqjvc1.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description of -e option was reformatted (unindented and enclosed
in an OpenBlock) in order to render the added line correctly.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
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

