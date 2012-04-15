Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2DOIjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 04:39:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2DOIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 04:39:00 -0400
Date: Sun, 15 Apr 2012 01:37:17 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-77394ad6e465ee3cc3d3cf448c8500c57ced60bf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1333948274-20043-1-git-send-email-namhyung.kim@lge.com>
References: <1333948274-20043-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Ignore auto-generated bison/
 flex files
Git-Commit-ID: 77394ad6e465ee3cc3d3cf448c8500c57ced60bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Apr 2012 01:37:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77394ad6e465ee3cc3d3cf448c8500c57ced60bf
Gitweb:     http://git.kernel.org/tip/77394ad6e465ee3cc3d3cf448c8500c57ced60bf
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 9 Apr 2012 14:11:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 14 Apr 2012 13:50:39 -0300

perf tools: Ignore auto-generated bison/flex files

The commit 65f3e56e0c81 ("perf tools: Remove auto-generated bison/flex
files") removed those files from git, so they'll be listed on untracked
files after building perf. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333948274-20043-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 416684b..26b823b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -19,3 +19,5 @@ TAGS
 cscope*
 config.mak
 config.mak.autogen
+*-bison.*
+*-flex.*
