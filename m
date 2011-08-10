Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HJI0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:26:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:50542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HJI0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:26:38 -0400
Date: Wed, 10 Aug 2011 08:26:10 GMT
From: tip-bot for Kusanagi Kouichi <slash@ac.auone-net.jp>
Message-ID: <tip-8b7e0b34b8e94f34597e4b804bbb8bb7e27df040@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        slash@ac.auone-net.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, slash@ac.auone-net.jp,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110807083932.9C0E514C03B@msa103.auone-net.jp>
References: <20110807083932.9C0E514C03B@msa103.auone-net.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Make clean leaves some files
Git-Commit-ID: 8b7e0b34b8e94f34597e4b804bbb8bb7e27df040
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:26:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b7e0b34b8e94f34597e4b804bbb8bb7e27df040
Gitweb:     http://git.kernel.org/tip/8b7e0b34b8e94f34597e4b804bbb8bb7e27df040
Author:     Kusanagi Kouichi <slash@ac.auone-net.jp>
AuthorDate: Sun, 7 Aug 2011 17:39:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Aug 2011 09:43:22 -0300

perf tools: Make clean leaves some files

Use LIB_OBJS and BUILTIN_OBJS for .o files.

LIB_FILE is already prefixed with OUTPUT.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110807083932.9C0E514C03B@msa103.auone-net.jp
Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d0861bb..5bf48fc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -892,7 +892,7 @@ quick-install-html:
 ### Cleaning rules
 
 clean:
-	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
