Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2LTTO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:14:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2LTTN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] perf kmem: use ARRAY_SIZE instead of reinventing it
Date: Thu, 20 Dec 2012 14:11:16 -0500
Message-Id: <1356030701-16284-8-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/builtin-kmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 0b4b796..266031f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -614,8 +614,7 @@ static struct sort_dimension *avail_sorts[] = {
 	&pingpong_sort_dimension,
 };
 
-#define NUM_AVAIL_SORTS	\
-	(int)(sizeof(avail_sorts) / sizeof(struct sort_dimension *))
+#define NUM_AVAIL_SORTS	((int)ARRAY_SIZE(avail_sorts))
 
 static int sort_dimension__add(const char *tok, struct list_head *list)
 {
-- 
1.8.0

