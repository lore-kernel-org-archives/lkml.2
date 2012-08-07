Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2HGRAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:00:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55647 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2HGRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:00:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf tools: Basic bash completion support v2
Date: Tue,  7 Aug 2012 18:59:59 +0200
Message-Id: <1344358801-16383-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:

- Reuse the perf binary of the user to send the "perf --list-cmds"
and "perf list --raw-dump" instead of the default one. (suggested by
David Ahern)

- Install in DESTDIR_SQ (suggested by David Ahern)

- Protect $cur under quotes on compgen cmdline (suggested by Alan Cox)

Frederic Weisbecker (2):
  perf tools: Initial bash completion support
  perf tools: Support for events bash completion

 tools/perf/Makefile            |    1 +
 tools/perf/bash_completion     |   26 +++++++++++++++
 tools/perf/builtin-list.c      |   14 ++++---
 tools/perf/perf.c              |   69 ++++++++++++++++++++++-----------------
 tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++---------------
 tools/perf/util/parse-events.h |    7 ++--
 6 files changed, 122 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/bash_completion

-- 
1.7.5.4

