Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1BEKkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:40:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:60993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1BEKkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:40:22 -0500
Date: Sat, 5 Feb 2011 10:40:20 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com
Subject: [PATCH 2/2] sysclt_check: Drop dead code
Message-ID: <20110205104020.GA2779@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Feb 2011 10:40:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop dead code.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 kernel/sysctl_check.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 3a01c3e..4e4932a 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -145,10 +145,6 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 			if (!table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
-#if 0
-			if (!table->procname && table->proc_handler)
-				set_fail(&fail, table, "proc_handler without procname");
-#endif
 			sysctl_check_leaf(namespaces, table, &fail);
 		}
 		if (table->mode > 0777)
-- 
1.7.3.4

