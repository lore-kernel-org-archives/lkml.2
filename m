Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2GRDIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 23:08:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41619 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2GRDIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 23:08:44 -0400
MIME-Version: 1.0
Date: Wed, 18 Jul 2012 11:08:42 +0800
Message-ID: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
Subject: [PATCH] uprobe: fix misleading log entry
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 68232ef2decae95b807f2f3763e8ea99c1a3b2ae Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 18 Jul 2012 17:51:26 +0800
Subject: [PATCH] uprobe: fix misleading log entry

There don't have any 'r' prefix in uprobe event naming, remove it.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 kernel/trace/trace_uprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index cf382de..852a584 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
 	if (argv[0][0] == '-')
 		is_delete = true;
 	else if (argv[0][0] != 'p') {
-		pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
+		pr_info("Probe definition must be started with 'p' or '-'.\n");
 		return -EINVAL;
 	}

-- 
1.7.9.7
