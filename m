Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1CYVpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:45:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:33736 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1CYVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:45:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Namhyung Kim <namhyung@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/4] kdb: add usage string of 'per_cpu' command
Date: Fri, 25 Mar 2011 16:44:20 -0500
Message-Id: <1301089460-1936-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
References: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Mar 2011 21:44:24.0363 (UTC) FILETIME=[CEB00FB0:01CBEB35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 38a8542..6bc6e3b 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2892,7 +2892,7 @@ static void __init kdb_inittab(void)
 	  "Send a signal to a process", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("summary", kdb_summary, "",
 	  "Summarize the system", 4, KDB_REPEAT_NONE);
-	kdb_register_repeat("per_cpu", kdb_per_cpu, "",
+	kdb_register_repeat("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
 	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
 	kdb_register_repeat("grephelp", kdb_grep_help, "",
 	  "Display help on | grep", 0, KDB_REPEAT_NONE);
-- 
1.7.1

