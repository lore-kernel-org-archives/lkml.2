Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2F1VTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2F1VTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:19:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: namhyung@kernel.org, bookjovi@gmail.com, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf, tool: Hw breakpoint events parsing fixes
Date: Thu, 28 Jun 2012 23:18:47 +0200
Message-Id: <1340918329-3012-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20120628103223.GA1055@krava.redhat.com>
References: <20120628103223.GA1055@krava.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
patch 1 is the change we discussed, patch 2 is to fix hw breakpoint
event names.

Attached patches:
  1/2 perf, tool: Fix hw breakpoint's type modifier parsing
  2/2 perf, tool: Handle hw breakpoints event names via perf_evsel__name

jirka
---
 tools/perf/util/evsel.c             |   30 ++++++++++++++++++++++
 tools/perf/util/parse-events-test.c |   47 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   20 ++++++++++----
 tools/perf/util/parse-events.l      |    2 +-
 4 files changed, 92 insertions(+), 7 deletions(-)
