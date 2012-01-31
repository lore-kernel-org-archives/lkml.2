Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2AaNRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:17:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2AaNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:17:12 -0500
Date: Tue, 31 Jan 2012 05:16:57 -0800
From: tip-bot for Masanari Iida <standby24x7@gmail.com>
Message-ID: <tip-f9d36996564f91c517b75b02942015f7e09a6574@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        standby24x7@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        standby24x7@gmail.com
In-Reply-To: <1327500312-9520-1-git-send-email-standby24x7@gmail.com>
References: <1327500312-9520-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Fix spelling typo
Git-Commit-ID: f9d36996564f91c517b75b02942015f7e09a6574
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:17:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9d36996564f91c517b75b02942015f7e09a6574
Gitweb:     http://git.kernel.org/tip/f9d36996564f91c517b75b02942015f7e09a6574
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Wed, 25 Jan 2012 15:20:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 17:25:30 -0200

perf evsel: Fix spelling typo

Correct spelling "unsuported" to "unsupported" in
tools/peft/util/evsel.c

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: standby24x7@gmail.com
Cc: trivial@kernel.org
Link: http://lkml.kernel.org/r/1327500312-9520-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..dcfefab 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -535,7 +535,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
+		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
 		return -1;
 	}
 
