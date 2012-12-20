Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2LTTPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49061 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2LTTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:17 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] perf script: use ARRAY_SIZE instead of reinventing it
Date: Thu, 20 Dec 2012 14:11:19 -0500
Message-Id: <1356030701-16284-11-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b363e7b..3314ef2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -692,7 +692,7 @@ static int parse_output_fields(const struct option *opt __maybe_unused,
 			    const char *arg, int unset __maybe_unused)
 {
 	char *tok;
-	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int i, imax = ARRAY_SIZE(all_output_options);
 	int j;
 	int rc = 0;
 	char *str = strdup(arg);
-- 
1.8.0

