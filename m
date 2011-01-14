Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1ANJ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:59:36 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38896 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab1ANJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:59:11 -0500
X-AuditID: b753bd60-9f090ba000000ca4-f2-4d301e6c05e3
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core ] perf probe: Update perf-probe.txt for --funcs
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Jan 2011 18:53:24 +0900
Message-ID: <20110114095324.4669.90160.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <4D301C37.2040303@hitachi.com>
References: <4D301C37.2040303@hitachi.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a documentation about functions listing option
to perf-probe.txt

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Original-patch-from: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Documentation/perf-probe.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 32d4af3..4df425a 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -73,6 +73,10 @@ OPTIONS
 	(Only for --vars) Show external defined variables in addition to local
 	variables.
 
+-F::
+--funcs::
+	Show available functions in given module or kernel.
+
 --filter=FILTER::
 	(Only for --vars and --funcs) Set filter for variables. FILTER is a
 	combination of glob pattern, see FILTER PATTERN for detail.

