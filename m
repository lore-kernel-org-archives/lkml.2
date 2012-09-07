Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab2IGGMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:12:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2IGGMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:12:22 -0400
Date: Thu, 6 Sep 2012 23:12:00 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ae42c6bb9300cf25990bd15f1bd6ee38598f7483@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
References: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Fix a typo on evsel
Git-Commit-ID: ae42c6bb9300cf25990bd15f1bd6ee38598f7483
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:12:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae42c6bb9300cf25990bd15f1bd6ee38598f7483
Gitweb:     http://git.kernel.org/tip/ae42c6bb9300cf25990bd15f1bd6ee38598f7483
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 6 Sep 2012 11:10:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Sep 2012 10:49:03 -0300

perf header: Fix a typo on evsel

For checking return value of the strdup, 'event' should be 'evsel'.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346897446-16569-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 43425b7..8b0b873 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2307,7 +2307,7 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
 
 	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
 	evsel->name = strdup(bf);
-	if (event->name == NULL)
+	if (evsel->name == NULL)
 		return -1;
 
 	evsel->tp_format = event;
