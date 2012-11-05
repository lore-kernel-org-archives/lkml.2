Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2KEXJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:09:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33304 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192Ab2KEXFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:39 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 103/104] mm: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:05:00 -0800
Message-Id: <1352156701-4038-104-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Jan Beulich <JBeulich@novell.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..679945e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,6 +1,5 @@
 config SELECT_MEMORY_MODEL
 	def_bool y
-	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
 
 choice
 	prompt "Memory model"
-- 
1.7.9.5

