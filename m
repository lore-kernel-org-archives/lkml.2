Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1IZJM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1IZJM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:12:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com
Subject: [PATCHv2 1/2] perf tools: Fix tracing info recording
Date: Mon, 26 Sep 2011 11:11:50 +0200
Message-Id: <1317028312-5156-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20110925133406.GB2702@jolsa.brq.redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I modified the patch based on your comments and separated
it into 2 parts:

- 1/2 perf tools: Collect tracing event data files directly
- 2/2 perf tools: Fix tracing info recording

thanks for comments,
jirka
---
 tools/perf/util/header.c           |   50 +++++-
 tools/perf/util/parse-events.h     |    1 +
 tools/perf/util/trace-event-info.c |  309 +++++++++++++++++++-----------------
 tools/perf/util/trace-event.h      |   11 +-
 4 files changed, 212 insertions(+), 159 deletions(-)
