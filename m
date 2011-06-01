Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1FANOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:14:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38901 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1FANOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:14:53 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] sysctl: remove impossible condition check
Date: Wed,  1 Jun 2011 10:15:05 -0300
Message-Id: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/proc/proc_sysctl.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 2e5d3ec..98e82d4 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -52,11 +52,8 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 {
 	int len;
 	for ( ; p->procname; p++) {
-
-		if (!p->procname)
-			continue;
-
 		len = strlen(p->procname);
+
 		if (len != name->len)
 			continue;
 
-- 
1.7.5.2

