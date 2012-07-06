Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab2GFKvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:51:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:50:59 -0400
Date: Fri, 6 Jul 2012 03:50:41 -0700
From: tip-bot for Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
Message-ID: <tip-f526a4ce2643e2636c091cf2bf0ec1442110c5b7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, konstantin.stepanyuk@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, konstantin.stepanyuk@gmail.com
In-Reply-To: <1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com>
References: <1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fix clean target in Makefile
Git-Commit-ID: f526a4ce2643e2636c091cf2bf0ec1442110c5b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:50:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f526a4ce2643e2636c091cf2bf0ec1442110c5b7
Gitweb:     http://git.kernel.org/tip/f526a4ce2643e2636c091cf2bf0ec1442110c5b7
Author:     Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
AuthorDate: Wed, 27 Jun 2012 15:52:14 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:11 -0300

tools lib traceevent: Fix clean target in Makefile

Dependency files were not cleaned up. Add missing space to fix the issue.

Signed-off-by: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3d69aa9..423f4b8 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -290,7 +290,7 @@ install_lib: all_cmd install_plugins install_python
 install: install_lib
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES).*.d
+	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
 	$(RM) tags TAGS
 
 endif # skip-makefile
