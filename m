Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1IGXOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:14:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42737 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab1IGXOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:14:31 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 5/5] perf stat: fix spelling in comment
Date: Wed,  7 Sep 2011 17:14:04 -0600
Message-Id: <1315437244-3788-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
References: <20110902185857.GE17970@ghostprotocols.net>
 <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b3e6e56..92c27a2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1209,7 +1209,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	 * let the spreadsheet do the pretty-printing
 	 */
 	if (csv_output) {
-		/* User explicitely passed -B? */
+		/* User explicitly passed -B? */
 		if (big_num_opt == 1) {
 			fprintf(stderr, "-B option not supported with -x\n");
 			usage_with_options(stat_usage, options);
-- 
1.7.4.4

