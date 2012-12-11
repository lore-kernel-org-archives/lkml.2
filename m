Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2LKWvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:51:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2LKWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/37] perf diff: Remove displacement from struct hist_entry_diff
Date: Tue, 11 Dec 2012 19:48:01 -0300
Message-Id: <1355266103-17238-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing displacement from struct hist_entry_diff, because it's not
used. Displacement is not used for sorting, so there's no reason to
pre-calculate it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1354110769-2998-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 91ae274..a1c0d56 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -55,9 +55,6 @@ struct he_stat {
 struct hist_entry_diff {
 	bool	computed;
 
-	/* PERF_HPP__DISPL */
-	int	displacement;
-
 	/* PERF_HPP__DELTA */
 	double	period_ratio_delta;
 
-- 
1.7.9.2.358.g22243

