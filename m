Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2LTTSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:18:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2LTTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:02 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Jason Wessel <jason.wessel@windriver.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kdb: use ARRAY_SIZE where possible
Date: Thu, 20 Dec 2012 14:11:27 -0500
Message-Id: <1356030701-16284-19-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/debug/kdb/kdb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 4d5f8d5..18ce064 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -124,7 +124,7 @@ static kdbmsg_t kdbmsgs[] = {
 };
 #undef KDBMSG
 
-static const int __nkdb_err = sizeof(kdbmsgs) / sizeof(kdbmsg_t);
+static const int __nkdb_err = ARRAY_SIZE(kdbmsgs);
 
 
 /*
@@ -175,7 +175,7 @@ static char *__env[] = {
  (char *)0,
 };
 
-static const int __nenv = (sizeof(__env) / sizeof(char *));
+static const int __nenv = ARRAY_SIZE(__env);
 
 struct task_struct *kdb_curr_task(int cpu)
 {
-- 
1.8.0

