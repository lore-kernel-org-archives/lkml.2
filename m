Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0KSVaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:30:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59318 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0KSVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:30:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf python scripting: Fixup cut'n'paste error in sctop script
Date: Fri, 19 Nov 2010 19:29:44 -0200
Message-Id: <1290202186-25352-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/python/sctop.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
index 547cbe9..7a6ec2c 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -17,7 +17,7 @@ from perf_trace_context import *
 from Core import *
 from Util import *
 
-usage = "perf trace -s syscall-counts.py [comm] [interval]\n";
+usage = "perf trace -s sctop.py [comm] [interval]\n";
 
 for_comm = None
 default_interval = 3
-- 
1.6.2.5

