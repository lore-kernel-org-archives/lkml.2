Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab2DIFL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 01:11:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54059 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2DIFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 01:11:25 -0400
X-AuditID: 9c93016f-b7b13ae000002492-08-4f826f7a2dd0
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Ignore auto-generated bison/flex files
Date: Mon,  9 Apr 2012 14:11:14 +0900
Message-Id: <1333948274-20043-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 65f3e56e0c81 ("perf tools: Remove auto-generated
bison/flex files") removed those files from git, so they'll
be listed on untracked files after building perf. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 416684be0ad3..26b823b61aa1 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -19,3 +19,5 @@ TAGS
 cscope*
 config.mak
 config.mak.autogen
+*-bison.*
+*-flex.*
-- 
1.7.7.6

