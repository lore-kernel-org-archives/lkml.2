Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1GNJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1GNJZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:25:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf tools: Add automated tests for events parsing
Date: Thu, 14 Jul 2011 11:25:31 +0200
Message-Id: <1310635534-4013-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'm adding automated test for parse_events function (patch 2/3).
I needed to change the parse_events interface slightly (patch 1/3).
Also using debugfs_path in trace_event__id so the path is not
hardcoded (patch 3/3).

attached patches:
 - 1/3 perf tools: De-opt the parse_events function
 - 2/3 perf tools: Add automated tests for events parsing
 - 3/3 perf tools: Make test use the preset debugfs path

wbr,
jirka
---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-stat.c      |    2 +-
 tools/perf/builtin-test.c      |  240 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/util/parse-events.c |   25 +++--
 tools/perf/util/parse-events.h |    6 +-
 6 files changed, 261 insertions(+), 16 deletions(-)
