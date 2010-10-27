Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759Ab0J0LCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:02:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:45597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab0J0LCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:02:19 -0400
Date: Wed, 27 Oct 2010 11:01:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python scripting: Fixup cut'n'paste error in sctop script
Message-ID: <tip-22d0594b31046793dfb58b7ce866d7cb0a9862e5@git.kernel.org>
Git-Commit-ID: 22d0594b31046793dfb58b7ce866d7cb0a9862e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 11:01:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22d0594b31046793dfb58b7ce866d7cb0a9862e5
Gitweb:     http://git.kernel.org/tip/22d0594b31046793dfb58b7ce866d7cb0a9862e5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 Oct 2010 15:21:15 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 26 Oct 2010 15:21:15 -0200

perf python scripting: Fixup cut'n'paste error in sctop script

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
