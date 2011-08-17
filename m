Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1HQHLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1HQHLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:11:42 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [Patch] makefile: remove a duplicated line
Date: Wed, 17 Aug 2011 15:10:52 +0800
Message-Id: <1313565052-7293-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two duplicated lines for 'make RECORDMCOUNT_WARN=1 [targets]'
in 'make help', remove the second one.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Makefile b/Makefile
index 3241d41..b7a08ae 100644
--- a/Makefile
+++ b/Makefile
@@ -1296,7 +1296,6 @@ help:
 	@echo  '		2: warnings which occur quite often but may still be relevant'
 	@echo  '		3: more obscure warnings, can most likely be ignored'
 	@echo  '		Multiple levels can be combined with W=12 or W=123'
-	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
