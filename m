Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1LLPRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:17:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46151 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1LLPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:12 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip:perf/core 0/8] random tiny perf fixes and cleanups
Date: Tue, 13 Dec 2011 00:16:49 +0900
Message-Id: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a patchset for what I found during a code review.
As you can see all of these are simple few-liners.
Please take a look and consider applying them.

Thanks.


Namhyung Kim (8):
  perf report: Document '--call-graph' for optional print_limit argument
  perf symbols: Get rid of duplicated snprintf()
  perf symbols: Fix error path on symbol__init()
  perf tools: Fix a memory leak on perf_read_values_destroy
  perf tools: Remove stale git headlines from top comment
  perf events: Tidy up perf_event__preprocess_sample
  perf report: Fix usage string
  perf evlist: Fix error handling on perf_event__mmap

 tools/perf/Documentation/perf-report.txt |    5 +++--
 tools/perf/builtin-report.c              |    8 ++++----
 tools/perf/util/config.c                 |    7 -------
 tools/perf/util/event.c                  |   13 +++++++------
 tools/perf/util/evlist.c                 |    8 ++++++--
 tools/perf/util/symbol.c                 |   11 +++--------
 tools/perf/util/usage.c                  |    5 -----
 tools/perf/util/values.c                 |    1 +
 8 files changed, 24 insertions(+), 34 deletions(-)

--
1.7.6

