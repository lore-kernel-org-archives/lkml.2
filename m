Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1BJCgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:36:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40124 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1BJCgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:36:11 -0500
X-AuditID: b753bd60-a42c8ba0000066fd-ed-4d534f17bda1
X-AuditID: b753bd60-a42c8ba0000066fd-ed-4d534f17bda1
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/makefile 2/2] perf tools: Rename old NO_PERL option
	to NO_LIBPERL
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2011 11:29:00 +0900
Message-ID: <20110210022900.15395.29169.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the valid option is NO_LIBPERL, NO_PERL should be
relpaced with NO_LIBPERL.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7e8a41..aea0c93 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,7 +34,7 @@ endif
 #
 # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
 #
-# Define NO_PERL if you do not want Perl scripts or libraries at all.
+# Define NO_LIBPERL if you do not want Perl scripts or libraries at all.
 #
 # Define LDFLAGS=-static to build a static binary.
 #
@@ -600,7 +600,7 @@ ifndef CC_LD_DYNPATH
 endif
 
 ifeq ($(PERL_PATH),)
-NO_PERL=NoThanks
+NO_LIBPERL=NoThanks
 endif
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
@@ -813,7 +813,7 @@ $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 # and the first level quoting from the shell that runs "echo".
 $(OUTPUT)PERF-BUILD-OPTIONS: .FORCE-PERF-BUILD-OPTIONS
 	@echo SHELL_PATH=\''$(subst ','\'',$(SHELL_PATH_SQ))'\' >$@
-	@echo NO_PERL=\''$(subst ','\'',$(subst ','\'',$(NO_PERL)))'\' >>$@
+	@echo NO_LIBPERL=\''$(subst ','\'',$(subst ','\'',$(NO_LIBPERL)))'\' >>$@
 
 ### Testing rules
 

