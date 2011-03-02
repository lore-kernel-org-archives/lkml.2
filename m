Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1CBMJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:09:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1CBMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:09:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P4KYlctU9llLOlTtYIhFstIIIaQCJ1+ym2UIXfXpSrwQYw1JUSkXxmq6yIiCtWuy5L
         +vDABT+C0lL90DfE2KV+2l+oI9qlHG5LghIsxvuk5kSev3e2G/JT5S8AsoD4qbGueFjL
         GPtfXLVFpQsyCis9j7AHMosqc3060VJLhGY+M=
From: Namhyung Kim <namhyung@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kdb: add usage string of 'per_cpu' command
Date: Wed,  2 Mar 2011 21:08:58 +0900
Message-Id: <1299067738-25680-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index bd3e8e29caa3..2486021ff5d9 100644
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
1.7.4

