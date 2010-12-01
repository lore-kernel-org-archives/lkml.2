Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0LASBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:52293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0LASBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/15] perf probe: Fix spelling mistake in documentation
Date: Wed,  1 Dec 2010 16:00:57 -0200
Message-Id: <1291226465-26337-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 62de1b7..4e23232 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -115,7 +115,7 @@ Each probe argument follows below syntax.
 
 LINE SYNTAX
 -----------
-Line range is descripted by following syntax.
+Line range is described by following syntax.
 
  "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
 
-- 
1.6.2.5

