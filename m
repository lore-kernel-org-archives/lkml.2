Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2CZPcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:32:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2CZPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:32:17 -0400
Date: Mon, 26 Mar 2012 08:32:05 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-2c86bf172e550b4bf089ac7f0de3f6370e243842@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1332753425-3299-1-git-send-email-jolsa@redhat.com>
References: <1332753425-3299-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Switch module.h into export.h
Git-Commit-ID: 2c86bf172e550b4bf089ac7f0de3f6370e243842
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 26 Mar 2012 08:32:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c86bf172e550b4bf089ac7f0de3f6370e243842
Gitweb:     http://git.kernel.org/tip/2c86bf172e550b4bf089ac7f0de3f6370e243842
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 26 Mar 2012 11:17:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 26 Mar 2012 17:19:57 +0200

perf tools: Switch module.h into export.h

When merged to Linus's latest tree the perf build is broken
due to following change in lib/rbtree.c object:

  lib: reduce the use of module.h wherever possible
  commit 8bc3bcc93a2b4e47d5d410146f6546bca6171663
  Author: Paul Gortmaker <paul.gortmaker@windriver.com>
  Date:   Wed Nov 16 21:29:17 2011 -0500

We need to move module.h header into export.h.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: cjashfor@linux.vnet.ibm.com
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/r/1332753425-3299-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile                                |    2 +-
 .../perf/util/include/linux/{module.h => export.h} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b492e3a..2f42886 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -251,7 +251,7 @@ LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/module.h
+LIB_H += util/include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
diff --git a/tools/perf/util/include/linux/module.h b/tools/perf/util/include/linux/export.h
similarity index 100%
rename from tools/perf/util/include/linux/module.h
rename to tools/perf/util/include/linux/export.h
