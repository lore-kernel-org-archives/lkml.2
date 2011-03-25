Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1CYVpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:45:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:33733 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab1CYVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:45:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jovi Zhang <bookjovi@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/4] kdb: code cleanup to use macro instead of value
Date: Fri, 25 Mar 2011 16:44:18 -0500
Message-Id: <1301089460-1936-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
References: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Mar 2011 21:44:22.0676 (UTC) FILETIME=[CDAEA540:01CBEB35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

It's better to use macro KDB_BASE_CMD_MAX instead of 50

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index bd3e8e2..38a8542 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -78,7 +78,7 @@ static unsigned int kdb_continue_catastrophic;
 static kdbtab_t *kdb_commands;
 #define KDB_BASE_CMD_MAX 50
 static int kdb_max_commands = KDB_BASE_CMD_MAX;
-static kdbtab_t kdb_base_commands[50];
+static kdbtab_t kdb_base_commands[KDB_BASE_CMD_MAX];
 #define for_each_kdbcmd(cmd, num)					\
 	for ((cmd) = kdb_base_commands, (num) = 0;			\
 	     num < kdb_max_commands;					\
-- 
1.7.1

