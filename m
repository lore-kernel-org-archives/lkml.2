Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1I2PF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1I2PFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:05:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, nhorman@tuxdriver.com,
        eric.dumazet@gmail.com
Subject: [PATCHv3 0/2] perf tools: Fix tracing info recording
Date: Thu, 29 Sep 2011 17:05:07 +0200
Message-Id: <1317308709-9474-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1317028312-5156-1-git-send-email-jolsa@redhat.com>
References: <1317028312-5156-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
attached patches:
- 1/2 perf tools: Fix raw sample reading
- 2/2 perf tools: Fix tracing info recording

v3 changes:
 - I cut off the 1/2 patch from v2, and replaced it with another
   fix which I found out is needed during the testing.. ;)

 - The 2/2 patch is same as in v2, besides changing to the
   current tip tree.

thanks for comments,
jirka
---
 tools/perf/util/evsel.c            |    7 ++-
 tools/perf/util/header.c           |   50 +++++++++++++++---
 tools/perf/util/trace-event-info.c |  102 ++++++++++++++++++++++++++---------
 tools/perf/util/trace-event.h      |   11 +++-
 4 files changed, 132 insertions(+), 38 deletions(-)
