Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2ITWOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:14:01 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48523 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2ITWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:13:59 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 0/4] perf: android: configure hardcoded paths
Date: Fri, 21 Sep 2012 01:13:31 +0300
Message-Id: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

This is a set of patches that replace hardcoded paths used in perf with
configurable options in the Makefile.

This is helpful since Android does not have the same folder structure as Linux
(e.g. there is no /tmp or /bin/sh). For cross-compiling, Android uses tools with
a different name than their Linux counterparts (e.g. arm-eabi-objdump, 
arm-eabi-addr2line).

Thanks,
Irina


Irina Tirdea (4):
  perf tools: configure tmp path at build time
  perf tools: configure shell path at compile time
  perf annotate: configure objdump path at compile time
  perf tools: configure addr2line path at compile time

 tools/perf/Makefile                |   30 ++++++++++++++++++++++++++++--
 tools/perf/builtin-help.c          |    2 +-
 tools/perf/builtin-script.c        |   12 ++++++------
 tools/perf/perf-archive.sh         |   13 +++++++++++--
 tools/perf/util/annotate.c         |    5 +++--
 tools/perf/util/dso-test-data.c    |    2 +-
 tools/perf/util/map.c              |    3 ++-
 tools/perf/util/pmu.c              |    2 +-
 tools/perf/util/sort.c             |    2 +-
 tools/perf/util/symbol.c           |    2 +-
 tools/perf/util/trace-event-info.c |    2 +-
 11 files changed, 56 insertions(+), 19 deletions(-)

-- 
1.7.9.5

