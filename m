Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2IGCDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:03:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2IGCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:03:19 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-71-504955e4b9ef
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf tools: Ignore compiled python binaries
Date: Fri,  7 Sep 2012 10:55:53 +0900
Message-Id: <1346982953-30824-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It prevents mindless git add from adding those files.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 26b823b61aa1..8f8fbc227a46 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -21,3 +21,5 @@ config.mak
 config.mak.autogen
 *-bison.*
 *-flex.*
+*.pyc
+*.pyo
-- 
1.7.11.4

