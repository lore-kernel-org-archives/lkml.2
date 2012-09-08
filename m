Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2IHLid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:38:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2IHLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:38:28 -0400
Date: Sat, 8 Sep 2012 04:38:02 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9a2936878a198553a17d21d1e843aa574ad9fa38@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346982953-30824-1-git-send-email-namhyung@kernel.org>
References: <1346982953-30824-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Ignore compiled python binaries
Git-Commit-ID: 9a2936878a198553a17d21d1e843aa574ad9fa38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:38:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a2936878a198553a17d21d1e843aa574ad9fa38
Gitweb:     http://git.kernel.org/tip/9a2936878a198553a17d21d1e843aa574ad9fa38
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 7 Sep 2012 10:55:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 12:10:58 -0300

perf tools: Ignore compiled python binaries

It prevents mindless git add from adding those files.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346982953-30824-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 26b823b..8f8fbc2 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -21,3 +21,5 @@ config.mak
 config.mak.autogen
 *-bison.*
 *-flex.*
+*.pyc
+*.pyo
