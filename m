Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624Ab2HIOcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:32:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37907 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2HIOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:32:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/3] perf tools: Basic bash completion support v3
Date: Thu,  9 Aug 2012 16:31:50 +0200
Message-Id: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:

- Fix /etc config installation from Namhyung.

Frederic Weisbecker (2):
  perf tools: Initial bash completion support
  perf tools: Support for events bash completion

Namhyung Kim (1):
  perf tools: Fix /etc config related installation

 tools/perf/Makefile            |    3 ++
 tools/perf/bash_completion     |   26 +++++++++++++++
 tools/perf/builtin-list.c      |   14 ++++---
 tools/perf/perf.c              |   69 ++++++++++++++++++++++-----------------
 tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++---------------
 tools/perf/util/parse-events.h |    7 ++--
 6 files changed, 124 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/bash_completion

-- 
1.7.5.4

