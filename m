Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2FQO47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:56:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2FQO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:56:58 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Fix an error on perf-bench document
Date: Sun, 17 Jun 2012 23:55:48 +0900
Message-Id: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pipe should be messaging.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-bench.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index a3dbadb26ef5..d53d22f0c6ee 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -51,8 +51,8 @@ SUITES FOR 'sched'
 Suite for evaluating performance of scheduler and IPC mechanisms.
 Based on hackbench by Rusty Russell.
 
-Options of *pipe*
-^^^^^^^^^^^^^^^^^
+Options of *messaging*
+^^^^^^^^^^^^^^^^^^^^^^
 -p::
 --pipe::
 Use pipe() instead of socketpair()
-- 
1.7.9.2

