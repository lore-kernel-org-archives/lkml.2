Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2DONkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:40:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2DONkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:40:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] perf, tool: event parsing enhancements/fixes
Date: Sun, 15 Apr 2012 15:40:28 +0200
Message-Id: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
adding some enhancements/fixies for perf event parsing.

Attached patches:
  1/6 perf, tool: Split term type into value type and term type
  2/6 perf, tool: Move parse event automated tests to separated object
  3/6 perf, tool: Add support for displaying event parser debug info
  4/6 perf, tool: Use allocated list for each parsed event
  5/6 perf, tool: Separate 'mem:' event scanner bits
  6/6 perf, tool: Add hardcoded name term for pmu events

thanks,
jirka
---
 tools/perf/Makefile                 |   13 +-
 tools/perf/builtin-test.c           |  522 +--------------------------------
 tools/perf/util/parse-events-test.c |  560 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |  103 +++++--
 tools/perf/util/parse-events.h      |   43 ++--
 tools/perf/util/parse-events.l      |   26 ++-
 tools/perf/util/parse-events.y      |   93 +++++--
 tools/perf/util/pmu.c               |   85 ++++--
 tools/perf/util/pmu.h               |    2 +
 9 files changed, 821 insertions(+), 626 deletions(-)
