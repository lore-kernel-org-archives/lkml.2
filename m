Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0HPMlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:41:04 -0400
Received: from msa104.auone-net.jp ([61.117.18.164]:60531 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0HPMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:41:02 -0400
Date: Mon, 16 Aug 2010 21:41:00 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Don't use brace expansion.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20100816124101.1829415C039@msa104.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DASH doesn't support brace expansion.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 tools/perf/Makefile |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 41abb90..8fa851b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,8 +157,10 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)scripts/perl/Perf-Trace-Util/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/ui/browsers/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
 $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-- 
1.7.1

